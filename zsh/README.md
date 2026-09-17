# Zsh configuration

Read this before changing startup or moving settings. Shared configuration lives
here; machine-specific settings live in ignored `local/` files.

## Startup and ownership

`.zshenv` loads `env.zsh`, then optional `local/env.zsh`. `.zshrc` repeats that
environment setup for hosts whose bootstrap only sets `ZDOTDIR`, then loads:

1. `options.zsh`: history, shell options, and basic line-editor bindings.
2. Autoload declarations for `functions/`, followed by `completion.zsh`.
3. `tools.zsh`, `widgets.zsh`, and `aliases.zsh`.
4. Optional `local/interactive.zsh`: final machine overrides.

Put shared environment defaults in `env.zsh`, machine paths in `local/env.zsh`,
and machine aliases in `local/interactive.zsh`. Autoload files contain function
bodies; declare new helpers in `.zshrc`. Custom completions live in `completions/`.

## Install

Review existing host startup files, preserve their settings, and merge this
bootstrap into `~/.zshenv`:

```zsh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ ! -r "$ZDOTDIR/.zshenv" ]] || source "$ZDOTDIR/.zshenv"
```

A fresh checkout works without local overrides. Older hosts using `zsh/zshrc`
or `work.d` overlays must migrate to the bootstrap and local files above.
Keep existing XDG overrides: moving cache/data locations is a separate migration.

Optional macOS key-repeat preference: run
`defaults write -g ApplePressAndHoldEnabled -bool false` manually.

## Rules for changes

- Keep environment setup silent, subprocess-free, and repeatable. Append missing
  PATH entries without reordering inherited entries, including in local settings.
  Keep `FPATH` unexported to avoid stale Homebrew paths in child shells.
- Keep one explicit startup sequence and `compinit` security checks. Scope
  helper options locally; completion functions must preserve compsys options
  using `LOCAL_OPTIONS` rather than resetting them with `emulate`.
- Enable `SHARE_HISTORY` with both incremental history options disabled.
- Evaluate generated initialization at source-file scope only after its command
  succeeds. Measure before adding caching or lazy-loading machinery.
- File/directory pickers collect a successful `fd` scan before opening Skim.
  This trades streaming for simple error handling and stores results in memory.
  Keep NUL delimiters end-to-end so newlines in filenames survive. Failures and
  cancellation must leave the command buffer unchanged.
- Treat `local/` and `work.d/` as private. Inspect only what the task requires;
  never dump or trace credentials. Preserve ignore rules. This machine sources
  its private secrets file from `local/interactive.zsh`.
- Preserve existing user edits. Test `ha` stop/delete behavior with stubs;
  those commands affect real sessions. Keep Skim's `accept(...)` key protocol.

## Verification

From the repository root:

```zsh
git status --short
zsh -df -c 'for f in zsh/.zshenv zsh/.zshrc zsh/*.zsh zsh/functions/* zsh/completions/*; do zsh -n "$f" || exit; done'
git diff --check
env -i PATH=/usr/bin:/bin:/opt/homebrew/bin:/usr/local/bin TERM=xterm-256color zsh -dfi zsh/tests/check.zsh
```

The suite requires `jq`, uses temporary state and offline executables, and
avoids private overrides and live sessions. It checks startup, PATH, generated
initialization, completion options, filename boundaries, scan errors, and
cancellation. Live picker rendering remains a manual check.

Update this README when the startup contract changes. Keep only outstanding
work in [TODO.md](TODO.md).
