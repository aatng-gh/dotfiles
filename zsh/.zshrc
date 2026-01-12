# Shell
export TERM=xterm-256color
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
typeset -U path
autoload -Uz compinit
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/compdump"

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=20000
SAVEHIST=20000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Rancher Desktop
path=("$HOME/.rd/bin" $path)

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
command -v starship >/dev/null && eval "$(starship init zsh)"

# Kind
command -v kind >/dev/null && source <(kind completion zsh)

# Fzf
command -v fzf >/dev/null && source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
    --prompt='(fzf)  ' \
    --pointer='▶' \
    --marker='✓' \
    --layout=reverse \
    --color=bg:#090E13,fg:#C5C9C7
    --color=bg+:#393B44,fg+:#C5C9C7
    --color=hl:#c4b28a,hl+:#E6C384
    --color=gutter:-1
    --color=pointer:#8a9a7b,marker:#87a987,header:#8ba4b0
    --color=info:#b6927b,prompt:#8a9a7b,spinner:#8ea4a2
"

# Zoxide
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Aliases
alias v="nvim"
alias vv="NVIM_APPNAME=nvim-new nvim"
alias g="lazygit"
alias k="kubectl"
