# Run from a clean process: zsh -dfi zsh/tests/check.zsh
# All state and executable stubs live in a temporary fixture.
setopt ERR_EXIT
repo=${0:A:h:h}
fixture=$(mktemp -d "${TMPDIR:-/tmp}/zsh-check.XXXXXX")
trap 'command rm -r -- "$fixture"' EXIT
fail() { print -u2 -r -- "FAIL: $*"; exit 1; }
mkdir -p "$fixture/home" "$fixture/config/zsh" "$fixture/bin"
for file in .zshenv .zshrc env.zsh options.zsh completion.zsh tools.zsh widgets.zsh aliases.zsh functions completions; do
  ln -s "$repo/$file" "$fixture/config/zsh/$file"
done
for tool in fd sk herdr starship zoxide; do
  ln -s "$repo/tests/fixtures/tool" "$fixture/bin/$tool"
done
export HOME="$fixture/home" XDG_CONFIG_HOME="$fixture/config"
export XDG_CACHE_HOME="$fixture/cache" XDG_STATE_HOME="$fixture/state"
export XDG_DATA_HOME="$fixture/data" ZDOTDIR="$fixture/config/zsh"
export PATH="$fixture/bin:/usr/bin:/bin:/opt/homebrew/bin:/usr/local/bin"
unset INIT_EXIT FD_EXIT FD_EMPTY SK_EXIT SK_LOG
source "$ZDOTDIR/.zshrc"
[[ $ZSH_TEST_STARSHIP == loaded && $ZSH_TEST_ZOXIDE == loaded && $ZSH_TEST_HERDR == loaded ]] || fail 'top-level generated initialization'
[[ $_comps[ha] == _ha ]] || fail 'completion registration'
[[ $options[sharehistory] == on && $options[incappendhistory] == off ]] || fail 'history policy'
bindkey '^R' | /usr/bin/grep -q _dotfiles_skim_history_widget || fail 'history binding'

# Preserve an arbitrary activated environment in this shell and child shells.
path=(/fixture/venv/bin $path)
export VIRTUAL_ENV=/fixture/venv
before=$PATH
source "$ZDOTDIR/.zshenv"
source "$ZDOTDIR/.zshrc"
[[ $PATH == $before ]] || fail 'inherited PATH order'
/bin/zsh -dc '[[ $path[1] == /fixture/venv/bin ]]' || fail 'child PATH order'
export MANPATH=/fixture/manuals
source "$ZDOTDIR/.zshenv"
source "$ZDOTDIR/.zshenv"
[[ $MANPATH == :/fixture/manuals ]] || fail 'manual search path'

# A failed generator emits plausible code, which must never be evaluated.
unset ZSH_TEST_STARSHIP ZSH_TEST_ZOXIDE ZSH_TEST_HERDR
export INIT_EXIT=42
source "$repo/tools.zsh" 2>"$fixture/init-errors"
source "$repo/completion.zsh" 2>>"$fixture/init-errors"
(( ! ${+ZSH_TEST_STARSHIP} && ! ${+ZSH_TEST_ZOXIDE} && ! ${+ZSH_TEST_HERDR} )) || fail 'failed output was evaluated'
[[ $(/usr/bin/grep -c 'status 42' "$fixture/init-errors") == 3 ]] || fail 'initialization failure diagnostics'
unset INIT_EXIT

# _ha must preserve the option environment provided by compsys.
setopt EXTENDED_GLOB NULL_GLOB
CURRENT=2
_describe() {
  [[ $options[extendedglob] == on && $options[nullglob] == on && $names[1] == demo:running ]]
}
_ha || fail 'completion options or candidates'
[[ $options[pipefail] == off ]] || fail 'completion option leakage'

# Exercise widget logic without a live ZLE or TUI. Decode its shell quoting
# against trusted fixture names to check exact argument boundaries.
zle() { return 0; }
LBUFFER=''
_dotfiles_skim_file_widget || fail 'file selection'
eval "selected=($LBUFFER)"
[[ $#selected == 3 && $selected[1] == 'space name' && $selected[2] == $'line\nname\n' && $selected[3] == -leading ]] || fail 'NUL-delimited filename round trip'

# A single directory with embedded AND trailing newlines remains intact.
_skim() { /bin/cat >/dev/null; print -rn -- $'line\nname\n\0'; }
_dotfiles_skim_cd_widget || fail 'directory selection'
eval "selected=($BUFFER)"
[[ $#selected == 4 && $selected[4] == $'line\nname\n' ]] || fail 'directory quoting'
unfunction _skim
autoload -Uz _skim

export FD_EXIT=41
export SK_LOG="$fixture/sk-called"
LBUFFER=unchanged
BUFFER=unchanged
if _dotfiles_skim_file_widget 2>"$fixture/scan-errors"; then fail 'lost fd failure'; else [[ $? == 41 ]] || fail 'wrong fd status'; fi
[[ $LBUFFER == unchanged ]] || fail 'file buffer changed on failure'
export SK_EXIT=1
if _dotfiles_skim_cd_widget 2>>"$fixture/scan-errors"; then fail 'lost scan failure with empty picker'; else [[ $? == 41 ]] || fail 'scan failure priority'; fi
[[ $BUFFER == unchanged ]] || fail 'directory buffer changed on failure'
[[ ! -e $SK_LOG ]] || fail 'picker opened after failed scan'
export FD_EXIT=0 FD_EMPTY=1 SK_EXIT=0
if _dotfiles_skim_file_widget; then fail 'empty scan succeeded'; else [[ $? == 1 ]] || fail 'empty scan status'; fi
[[ ! -e $SK_LOG && $LBUFFER == unchanged ]] || fail 'empty scan opened picker or changed buffer'
unset FD_EMPTY
export SK_EXIT=130
if _dotfiles_skim_file_widget 2>"$fixture/cancel-errors"; then fail 'lost cancellation'; else [[ $? == 130 ]] || fail 'cancellation status'; fi
[[ ! -s "$fixture/cancel-errors" ]] || fail 'cancellation reported as scan failure'
[[ $LBUFFER == unchanged ]] || fail 'buffer changed on cancellation'
unset FD_EXIT SK_EXIT SK_LOG
HISTFILE=/dev/null
print 'PASS: startup, PATH, initialization, completion, NUL filenames, failed/empty scans, cancellation'
