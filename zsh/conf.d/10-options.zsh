# ---- history ----
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}" 2>/dev/null
setopt EXTENDED_HISTORY HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_REDUCE_BLANKS
setopt SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY

# ---- options ----
setopt AUTO_CD EXTENDED_GLOB INTERACTIVE_COMMENTS NO_BEEP

# ---- line editor ----
bindkey -e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# prefix-search history with up/down
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
