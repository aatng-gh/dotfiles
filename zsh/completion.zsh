autoload -Uz compinit
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -i -d "$XDG_CACHE_HOME/zsh/compdump"

if (( $+commands[herdr] )); then
  if _dotfiles_init_code=$(command herdr completion zsh); then
    eval "$_dotfiles_init_code"
  else
    print -u2 -r -- "herdr completion initialization failed (status $?)"
  fi
  unset _dotfiles_init_code
fi

# Explicit registration also works with an existing completion dump.
autoload -Uz _ha
compdef _ha ha
zstyle ':completion:*:ha:*:sessions' list-grouped false
