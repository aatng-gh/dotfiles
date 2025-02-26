# +---  History  ---+
HISTFILE=$HOME/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# +---  Tab Completion  ---+
autoload -Uz compinit
if [[ ! -e "$ZSH_COMPDUMP" || "$ZSH_COMPDUMP" -ot ~/.zshrc ]]; then
    compinit
else
    compinit -C
fi

# +---  Envs  ---+
export COLORTERM=truecolor
export EDITOR="nvim"
export VISUAL='nvim'
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

export PATH="/opt/homebrew/bin:$HOME/.config/scripts:/Users/aaron/.local/bin:$PATH"

# +---  Starship  ---+
eval "$(starship init zsh)"

# +---  Brew  ---+
eval "$(/opt/homebrew/bin/brew shellenv)"

# +---  Nvm  ---+
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    . "/opt/homebrew/opt/nvm/nvm.sh"
    . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# +---  Aliases  ---+
[ "$TERM" = "xterm-kitty" ] && \
    alias ssh="kitty +kitten ssh"

alias python="/usr/bin/python3"
alias g="lazygit"
alias d="lazydocker"
alias ls="ls -l --color=auto"
alias nv="nvim"

# +---  Fzf  ---+
export FZF_DEFAULT_OPTS="--color=fg:#BFBDB6,bg:#0D1017,hl:#39BAE6,fg+:#BFBDB6,bg+:#131721,hl+:#E6B450,info:#565B66,prompt:#E6B450,pointer:#F07178,marker:#FFB454,spinner:#95E6CB,header:#475266,gutter:-1 --border=sharp --layout=reverse"
if command -v fzf &>/dev/null && [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

# +---  K8s  ---+
KUBE_COMPLETION=~/.kube/completion.zsh
if [ ! -s "$KUBE_COMPLETION" ]; then
    kubectl completion zsh > "$KUBE_COMPLETION"
fi
source "$KUBE_COMPLETION"
compdef k='kubectl'

alias k="kubectl"
alias kaf="kubectl apply -f"
