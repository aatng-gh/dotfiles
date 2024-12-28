# +---  Envs  ---+
export NVM_DIR="$HOME/.nvm"
export EDITOR="nvim"
export PATH="$HOME/.config/scripts:$PATH"
export PATH="$PATH:/Users/aaron/.local/bin"

# +---  Starship  ---+
eval "$(starship init zsh)"

# +---  Nvim  ---+
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# +---  Aliases  ---+
if [ "$TERM" = "xterm-kitty" ]; then
    alias ssh="kitty +kitten ssh"
fi

alias python="/usr/bin/python3"
alias lg="lazygit"
alias td="today.sh"

# +---  fzf  ---+
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--color=gutter:-1"
