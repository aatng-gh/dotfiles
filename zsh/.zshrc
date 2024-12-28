# +---  Zsh  ---+
HISTFILE=~/.cache/zsh/history

HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

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
export FZF_DEFAULT_OPTS="\
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 \
  --color=fg+:#c0caf5,bg+:#2a2e3f,hl+:#7dcfff \
  --color=info:#7aa2f7,prompt:#9d7cd8,pointer:#f7768e \
  --color=marker:#9ece6a,spinner:#bb9af7,header:#7dcfff \
  --color=gutter:-1"
source <(fzf --zsh)

# +---  Brew  ---+
eval "$(/opt/homebrew/bin/brew shellenv)"
