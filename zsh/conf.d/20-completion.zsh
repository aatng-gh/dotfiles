autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh" 2>/dev/null
compinit -i -d "$XDG_CACHE_HOME/zsh/compdump"

(( $+commands[herdr] )) && eval "$(herdr completion zsh)"

if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  autoload -Uz bashcompinit && bashcompinit
  source /opt/homebrew/etc/profile.d/bash_completion.sh
fi
