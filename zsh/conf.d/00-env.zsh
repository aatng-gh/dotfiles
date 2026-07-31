# ---- XDG ----
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ---- homebrew ----
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# brew shellenv exports FPATH, which leaks version-pinned Cellar paths to
# child shells and breaks them after a zsh upgrade. Keep fpath local.
typeset +x FPATH

# ---- path ----
typeset -U path PATH fpath
path=($HOME/.local/bin $path)

export MANPAGER='less -X'
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
