# Attach to a tmux session, creating it if needed. Defaults to "default".
t() { tmux new -As "${1:-default}" }

# Pick a tmux session with Skim. Switch instead of nesting when already in tmux.
ta() {
  local session
  session=$(
    tmux list-sessions -F '#S' 2>/dev/null |
      _skim --no-multi --height 20 --prompt 'tmux ❯ '
  ) || return
  [[ -n $session ]] || return
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}

# Pick a Herdr session: Enter attaches, ctrl-x stops, ctrl-d deletes.
# With a name, attach directly.
ha() {
  if (( $# )); then
    command herdr session attach "$@"
    return
  fi

  local rows
  rows=$(
    command herdr session list --json |
      jq -r '.sessions[] | [.name, (if .running then "running" else "stopped" end)] | @tsv'
  ) || return
  [[ -n $rows ]] || { print -u2 -r -- "no herdr sessions"; return 1; }

  # skim deprecated --expect into a silent no-op, so bind the keys to accept()
  # instead; it prints its argument as a first line ahead of the selection.
  local picked
  picked=$(
    print -r -- "$rows" |
      _skim --delimiter $'\t' --with-nth 1,2 --tabstop 16 --no-multi --height 10 \
        --prompt 'herdr ❯ ' \
        --bind 'ctrl-x:accept(ctrl-x),ctrl-d:accept(ctrl-d)' \
        --header 'enter attach · ctrl-x stop · ctrl-d delete'
  ) || return
  [[ -n $picked ]] || return

  local key='' selection=$picked
  if [[ $picked == *$'\n'* ]]; then
    key=${picked%%$'\n'*}
    selection=${picked#*$'\n'}
  fi
  local name=${selection%%$'\t'*} state=${selection#*$'\t'}

  case $key in
    ctrl-x) command herdr session stop "$name" ;;
    ctrl-d)
      # Delete only accepts stopped sessions, so stop first; say so because
      # this is the step that tears down any live agents.
      if [[ $state == running ]]; then
        print -r -- "stopping $name"
        command herdr session stop "$name" || return
      fi
      command herdr session delete "$name"
      ;;
    *) command herdr session attach "$name" ;;
  esac
}

# Herdr's own completion treats session names as free text, so <Tab> after
# `ha` asks the server for the real list and shows each session's state.
# _describe splits on the first bare colon, so colons in names get escaped.
_ha() {
  (( CURRENT == 2 )) || return 1
  local -a names
  names=(${(f)"$(command herdr session list --json 2>/dev/null |
    jq -r '.sessions[] | "\(.name | gsub(":"; "\\:")):\(if .running then "running" else "stopped" end)"')"})
  _describe -t sessions 'herdr session' names
}
compdef _ha ha
# Zsh folds matches that share a description onto one line, which turns two
# running sessions into "a  b  -- running"; keep one session per line.
zstyle ':completion:*:ha:*:sessions' list-grouped false

# Personal help files live at ~/.config/TOPIC/help.txt.
help() {
  local config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
  local topic="$1"
  local help_file

  if [[ -z "$topic" ]]; then
    print -r -- "Usage: help TOPIC"
    print -r -- ""
    print -r -- "Available topics:"
    for help_file in "$config_root"/*/help.txt(N); do
      print -r -- "  ${help_file:h:t}"
    done
    return
  fi

  help_file="$config_root/$topic/help.txt"
  if [[ ! -f "$help_file" ]]; then
    print -u2 -r -- "No help found for: $topic"
    return 1
  fi

  command cat -- "$help_file"
}

# Rows of "<branch>\t<path>" for every worktree of the current repo. Parsed
# from --porcelain because the human listing is space-aligned, so a path with a
# space in it cannot be split back out reliably.
_wt_rows() {
  git worktree list --porcelain 2>/dev/null | awk '
    $1 == "worktree" { path = substr($0, 10) }
    $1 == "HEAD"     { sha = substr($2, 1, 7) }
    $1 == "branch"   { b = substr($0, 19) }
    $1 == "detached" { b = "detached@" sha }
    $1 == "bare"     { b = "(bare)" }
    $0 == ""         { print b "\t" path; b = "" }'
}

# Pick a git worktree with Skim and cd into it. An argument pre-fills the
# query, so `wt vendor` opens the picker already narrowed; when it matches a
# single worktree (what tab completion inserts) skim skips the picker.
wt() {
  local rows
  rows=$(_wt_rows)
  [[ -n $rows ]] || { print -u2 -r -- "not a git repo"; return 1; }

  # --query= keeps a leading dash from being read as a flag.
  local target
  target=$(
    print -r -- "$rows" |
      _skim --delimiter $'\t' --with-nth 1,2 --tabstop 24 --no-multi --height 10 \
        --prompt 'worktree ❯ ' --query="${1-}" --select-1
  ) || return
  [[ -n $target ]] && builtin cd -- "${target##*$'\t'}"
}

# Completion is what makes the single-match shortcut reachable without
# memorising branch names.
_wt() {
  (( CURRENT == 2 )) || return 1
  local -a worktrees
  worktrees=(${(f)"$(_wt_rows | awk -F'\t' '{ print $1 ":" $2 }')"})
  _describe -t worktrees 'worktree' worktrees
}
compdef _wt wt
