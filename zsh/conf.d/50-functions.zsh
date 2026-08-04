# Attach to a tmux session, creating it if needed. Defaults to "default".
t() { tmux new -As "${1:-default}" }

# Pick a session with television. attach-session cannot nest, so switch when
# already inside tmux. Ctrl-x in the picker reaches the kill action.
ts() {
  local session
  session=$(tv tmux-sessions --height 20 --no-preview --no-remote) || return
  [[ -n $session ]] || return
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
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
