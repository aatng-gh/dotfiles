# tmux Keymap

This config uses `Ctrl-a` as the tmux prefix instead of the default `Ctrl-b`.

## Core

| Key | Action |
| --- | --- |
| `Ctrl-a` | tmux prefix |
| `Ctrl-a Ctrl-a` | Send literal `Ctrl-a` to the terminal |
| `Ctrl-a r` | Reload `~/.config/tmux/tmux.conf` and show `tmux reloaded` |
| `Ctrl-a $` | Rename the current session |

## Windows

| Key | Action |
| --- | --- |
| `Ctrl-a c` | Create a new window in the current pane's directory |
| `Ctrl-a X` | Close the current window, with confirmation |
| `Ctrl-a n` | Go to the next window |
| `Ctrl-a p` | Go to the previous window |
| `Ctrl-a a` | Go to the last active window |
| `Ctrl-a w` | Open the window/session chooser |
| `Ctrl-a ,` | Rename the current window |
| `Ctrl-a .` | Move the current window to a specific number |
| `Ctrl-a <` | Move the current window left |
| `Ctrl-a >` | Move the current window right |

## Panes

| Key | Action |
| --- | --- |
| `Ctrl-a |` | Split pane horizontally in the current pane's directory |
| `Ctrl-a -` | Split pane vertically in the current pane's directory |
| `Ctrl-a x` | Close the current pane, with confirmation |

Use vim-style pane navigation after the prefix:

| Key | Action |
| --- | --- |
| `Ctrl-a h` | Select pane left |
| `Ctrl-a j` | Select pane down |
| `Ctrl-a k` | Select pane up |
| `Ctrl-a l` | Select pane right |

Pane navigation and resizing bindings repeat while held.

| Key | Action |
| --- | --- |
| `Ctrl-a H` | Resize pane left by 15 cells |
| `Ctrl-a J` | Resize pane down by 15 cells |
| `Ctrl-a K` | Resize pane up by 15 cells |
| `Ctrl-a L` | Resize pane right by 15 cells |

## Copy Mode

| Key | Action |
| --- | --- |
| `Ctrl-a [` | Enter copy mode |
| `v` | Start selection |
| `V` | Select whole line |
| `y` | Copy selection and exit copy mode |
| `Space` | Start selection using tmux's default binding |
| `Enter` | Copy selection using tmux's default binding |

## Behavior

| Setting | Effect |
| --- | --- |
| Mouse support | Enabled for selecting panes, resizing panes, and scrolling |
| Scrollback | `100000` lines |
| Copy mode keys | vi-style |
| Window index | Starts at `1` |
| Pane index | Starts at `1` |
| Focus events | Enabled |
| Window numbering | Renumbered automatically after windows close |
| Last session detach | Keep tmux running instead of destroying the client |
| Terminal colors | `tmux-256color` with RGB support |
| Status line | Minimal bottom status using terminal colors, with prefix indicator, session, windows, current folder, pane count, date, and time |
| Window activity | Highlight tabs with background activity without showing pop-up notices |
