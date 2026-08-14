_skim() {
  if (( ! $+commands[sk] )); then
    print -u2 -r -- "Skim is required: brew install sk"
    return 127
  fi

  command sk --reverse --border plain --info inline \
    --selector '◆' --multi-selector '◇' "$@"
}

(( $+commands[sk] )) || return

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

_dotfiles_skim_file_widget() {
  local item selected=""
  zle -I

  while IFS= read -r item; do
    selected+="${(q)item} "
  done < <(
    command fd --hidden --follow --exclude .git --exclude node_modules \
      --type file --type directory --strip-cwd-prefix . |
      _skim --scheme path --multi --height 40% --prompt 'files ❯ '
  )

  [[ -n $selected ]] && LBUFFER+=$selected
  zle reset-prompt
}

_dotfiles_skim_cd_widget() {
  local directory result
  zle -I
  directory=$(
    command fd --hidden --follow --exclude .git --exclude node_modules \
      --type directory --strip-cwd-prefix . |
      _skim --scheme path --no-multi --height 40% --prompt 'cd ❯ '
  )
  result=$?
  (( result == 0 )) && [[ -n $directory ]] || {
    zle reset-prompt
    return $result
  }

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
