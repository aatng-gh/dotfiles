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
# Prioritize user bins and Homebrew over system paths without reordering
# inherited entries, activated environments, or version managers.
local -a _dotfiles_bins
_dotfiles_bins=("$HOME/.local/bin" "$XDG_CONFIG_HOME/bin")
if [[ -n $HOMEBREW_PREFIX && -x $HOMEBREW_PREFIX/bin/brew ]]; then
  _dotfiles_bins+=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
fi

local -a _dotfiles_pre _dotfiles_post
local _dotfiles_found_sys=0
local _dotfiles_dir
for _dotfiles_dir in $path; do
  if (( ${_dotfiles_bins[(Ie)$_dotfiles_dir]} != 0 )); then
    continue
  fi
  if (( ! _dotfiles_found_sys )); then
    if [[ $_dotfiles_dir == (/usr/local/bin|/usr/bin|/bin|/usr/sbin|/sbin|/System/*|/Library/*) ]]; then
      _dotfiles_found_sys=1
      _dotfiles_post+=("$_dotfiles_dir")
    else
      _dotfiles_pre+=("$_dotfiles_dir")
    fi
  else
    _dotfiles_post+=("$_dotfiles_dir")
  fi
done

if (( _dotfiles_found_sys )); then
  path=($_dotfiles_pre $_dotfiles_bins $_dotfiles_post)
else
  path=($_dotfiles_bins $path)
fi
unset _dotfiles_bins _dotfiles_pre _dotfiles_post _dotfiles_found_sys _dotfiles_dir

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export MANPAGER='less -X'
