# ENV VARIABLES
export NVM_DIR="$HOME/.nvm"

# SHELL CONFIG
eval "$(starship init zsh)"

# NVM SETUP
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# ALIASES
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
alias python=/usr/bin/python3
alias lg="lazygit"
