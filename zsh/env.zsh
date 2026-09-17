# ---- XDG ----
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Keep environment setup silent and subprocess-free, including for scripts.
typeset -U path PATH fpath
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
  export HOMEBREW_REPOSITORY=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX=/usr/local
  export HOMEBREW_REPOSITORY=/usr/local/Homebrew
fi
if [[ -n $HOMEBREW_PREFIX && -x $HOMEBREW_PREFIX/bin/brew ]]; then
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  path=($path "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
  # A leading empty entry preserves default manuals when MANPATH is customized.
  if [[ -n ${MANPATH-} && $MANPATH != :* ]]; then
    export MANPATH=":$MANPATH"
  fi
  # Preserve the default info search path without growing it in child shells.
  if [[ :${INFOPATH-}: != *:"$HOMEBREW_PREFIX/share/info":* ]]; then
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH-}"
  fi
fi

# brew shellenv exports FPATH, which leaks version-pinned Cellar paths to
# child shells and breaks them after a zsh upgrade. Keep fpath local.
typeset +x FPATH

# ---- path ----
# Existing order wins, including activated environments and version managers.
path=($path "$HOME/.local/bin" "$XDG_CONFIG_HOME/bin")

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export MANPAGER='less -X'
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
