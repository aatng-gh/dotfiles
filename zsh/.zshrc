[[ -o interactive ]] || return

# Add missing environment defaults without reordering inherited PATH entries.
# Also supports hosts whose ~/.zshenv only sets ZDOTDIR.
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshenv"

source "$XDG_CONFIG_HOME/zsh/options.zsh"
fpath=("$XDG_CONFIG_HOME/zsh/functions" "$XDG_CONFIG_HOME/zsh/completions" $fpath)
autoload -Uz t ta ha help _skim

source "$XDG_CONFIG_HOME/zsh/completion.zsh"
source "$XDG_CONFIG_HOME/zsh/tools.zsh"
source "$XDG_CONFIG_HOME/zsh/widgets.zsh"
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"

[[ ! -r "$XDG_CONFIG_HOME/zsh/local/interactive.zsh" ]] ||
  source "$XDG_CONFIG_HOME/zsh/local/interactive.zsh"
