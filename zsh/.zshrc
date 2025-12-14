# Shell
export TERM=xterm-256color
autoload -U compinit; compinit

# Rancher Desktop
export PATH="$HOME/.rd/bin:$PATH"

# Starship
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
eval "$(starship init zsh)"

# Kind
source <(kind completion zsh)

# FZF
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
    --prompt='(fzf)  ' \
    --pointer='▶' \
    --marker='✓' \
    --layout=reverse
    --color=bg:#090E13,fg:#C5C9C7
    --color=bg+:#393B44,fg+:#C5C9C7
    --color=hl:#c4b28a,hl+:#E6C384
    --color=gutter:-1
    --color=pointer:#8a9a7b,marker:#87a987,header:#8ba4b0
    --color=info:#b6927b,prompt:#8a9a7b,spinner:#8ea4a2
"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Aliases
alias v="nvim"
alias vv="NVIM_APPNAME=nvim-new nvim"
alias g="lazygit"
alias k="kubectl"
