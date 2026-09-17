_dotfiles_skim_history_candidates() {
  local event entry
  local -A seen

  for event in ${(Onk)history}; do
    entry=$history[$event]
    [[ -n ${seen[$entry]-} ]] && continue
    seen[$entry]=1
    print -r -- "$event"$'\t'"${entry//$'\n'/\\n}"
  done
}

_dotfiles_skim_history_widget() {
  local selection event result
  zle -I
  selection=$(
    _dotfiles_skim_history_candidates |
      _skim --scheme history --delimiter $'\t' --with-nth 2.. \
        --no-multi --height 40% --bind 'ctrl-r:toggle-sort' \
        --prompt 'history ❯ ' --query "$LBUFFER"
  )
  result=$?
  (( result == 0 )) || {
    zle reset-prompt
    return $result
  }

  event=${selection%%$'\t'*}
  [[ $event == <-> ]] || return 1
  zle vi-fetch-history -n "$event"
  zle reset-prompt
}

_dotfiles_skim_paths() {
  emulate -L zsh
  (( $+commands[fd] )) || { print -u2 -- 'fd is required: brew install fd'; return 127; }
  (( $+commands[sk] )) || { print -u2 -- 'Skim is required: brew install sk'; return 127; }
  local -a types picker
  case $1 in
    files) types=(--type file --type directory); picker=(--multi --prompt 'files ❯ ') ;;
    directories) types=(--type directory); picker=(--no-multi --prompt 'cd ❯ ') ;;
    *) return 2 ;;
  esac

  # Finish the scan before opening Skim so failures need no pipeline protocol.
  local candidates result
  candidates=$(
    command fd --hidden --follow --exclude .git --exclude node_modules \
      $types --print0 --strip-cwd-prefix .
  ) || {
    result=$?
    print -u2 -r -- "file scan failed (status $result)"
    return $result
  }
  [[ -n $candidates ]] || return 1

  # NUL terminators also preserve trailing newlines in command substitutions.
  print -rn -- "$candidates" |
    _skim --scheme path --read0 --print0 --height 40% $picker
}

_dotfiles_skim_file_widget() {
  emulate -L zsh
  local selection item selected='' result
  zle -I
  selection=$(_dotfiles_skim_paths files)
  result=$?
  if (( result == 0 )); then
    for item in "${(@0)selection}"; do
      [[ -n $item ]] && selected+="${(q)item} "
    done
    LBUFFER+=$selected
  fi

  zle reset-prompt
  return $result
}

_dotfiles_skim_cd_widget() {
  emulate -L zsh
  local selection directory result
  zle -I
  selection=$(_dotfiles_skim_paths directories)
  result=$?
  (( result == 0 )) || {
    zle reset-prompt
    return $result
  }

  directory=${selection%$'\0'}
  zle push-line
  BUFFER="builtin cd -- ${(q)directory}"
  zle accept-line
}

zle -N _dotfiles_skim_history_widget
zle -N _dotfiles_skim_file_widget
zle -N _dotfiles_skim_cd_widget
bindkey '^R' _dotfiles_skim_history_widget
bindkey '^T' _dotfiles_skim_file_widget
bindkey '\ec' _dotfiles_skim_cd_widget
