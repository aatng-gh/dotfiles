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

# Attach to a Herdr session. With no name, pick one interactively.
ha() {
  if (( $# )); then
    command herdr session attach "$@"
    return
  fi

  local selection
  selection=$(
    command herdr session list --json |
      jq -r '.sessions[] | [.name, (if .running then "running" else "stopped" end)] | @tsv' |
      _skim --delimiter $'\t' --with-nth 1,2 --no-multi --height 10 \
        --prompt 'herdr ❯ '
  ) || return
  [[ -n $selection ]] || return

  command herdr session attach "${selection%%$'\t'*}"
}

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
