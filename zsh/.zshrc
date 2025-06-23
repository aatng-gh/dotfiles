autoload -U compinit; compinit

alias nv="nvim"
alias g="lazygit"

source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
    --prompt='∷ ' \
    --pointer='▶' \
    --marker='⇒' \
    --layout=reverse \
    --height=60% \
    --color=bg:#192330,fg:#cdcecf \
    --color=bg+:#2b3b51,fg+:#cdcecf \
    --color=hl:#dbc074,hl+:#e0c989 \
    --color=gutter:-1 \
    --color=pointer:#63cdcf,marker:#81b29a,header:#719cd6 \
    --color=info:#9d79d6,prompt:#63cdcf,spinner:#63cdcf
"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

gp() {
  fd -t d -d 1 . $HOME/Dev | fzf --prompt='Projects ∷ '
}

eval "$(starship init zsh)"
