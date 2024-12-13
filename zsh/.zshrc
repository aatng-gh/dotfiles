# +---  Envs  ---+
export COLORTERM=truecolor
export EDITOR="nvim"
export VISUAL='nvim'

export NVM_DIR="$HOME/.nvm"
export PATH="$HOME/.config/scripts:$PATH"
export PATH="$PATH:/Users/aaron/.local/bin"

# +---  Starship  ---+
eval "$(starship init zsh)"

# +---  Nvim  ---+
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# +---  Aliases  ---+
[ "$TERM" = "xterm-kitty" ] && \
    alias ssh="kitty +kitten ssh"

alias python="/usr/bin/python3"
alias g="lazygit"
alias d="lazydocker"
alias k="kubectl"

# +---  fzf  ---+
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--color=gutter:-1"

# +---  Brew  ---+
eval "$(/opt/homebrew/bin/brew shellenv)"
