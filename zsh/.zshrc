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
# rose pine
export FZF_DEFAULT_OPTS="
  --prompt='› ' \
  --color=fg:#e0def4,bg:#191724,hl:#c4a7e7 \
  --color=fg+:#e0def4,bg+:#403d52,hl+:#f6c177 \
  --color=info:#9ccfd8,prompt:#f6c177,pointer:#eb6f92 \
  --color=marker:#31748f,spinner:#ebbcba,header:#6e6a86,gutter:-1 \
  --border=sharp --layout=reverse
"
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
