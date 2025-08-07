autoload -U compinit; compinit

export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
eval "$(starship init zsh)"

alias nv="nvim"
alias g="lazygit"

source <(fzf --zsh)


export FZF_DEFAULT_OPTS="
    --prompt='(fzf)  ' \
    --pointer='▶' \
    --marker='✓' \
    --layout=reverse
    --color=bg:#2d353b,fg:#d3c6aa
    --color=bg+:#343f44,fg+:#d3c6aa
    --color=hl:#dbbc7f,hl+:#e67e80
    --color=gutter:-1
    --color=pointer:#a7c080,marker:#a7c080,header:#7fbbb3
    --color=info:#e69875,prompt:#a7c080,spinner:#a7c080
"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

alias k="kubectl"
