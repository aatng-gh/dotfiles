# ---- history ----
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=120000
SAVEHIST=100000
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
setopt EXTENDED_HISTORY HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
unsetopt INC_APPEND_HISTORY INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY

# ---- options ----
setopt AUTO_CD EXTENDED_GLOB INTERACTIVE_COMMENTS NO_BEEP

# ---- line editor ----
bindkey -e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
