# ~/.zshenv sets ZDOTDIR and sources this file on a newly configured host.
source "${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/env.zsh"
[[ ! -r "$XDG_CONFIG_HOME/zsh/local/env.zsh" ]] ||
  source "$XDG_CONFIG_HOME/zsh/local/env.zsh"
