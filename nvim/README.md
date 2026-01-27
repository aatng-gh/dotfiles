# Neovim Config

Minimal custom Neovim setup centered on
[mini.nvim](https://github.com/echasnovski/mini.nvim).

## Overview

- Bootstraps `mini.nvim` (stable branch) in `init.lua`.
- Uses `mini.deps` for plugin management.
- Leader key is `<Space>` (`vim.g.mapleader = ' '`).

## Modules

- `plugin/10_options.lua`: core options and diagnostic display.
- `plugin/20_keymaps.lua`: keymaps and `mini.clue` leader groups.
- `plugin/30_mini.lua`: `mini.pick`, `mini.extra`, `mini.clue` setup.
- `plugin/40_plugins.lua`: Treesitter, LSP, formatting, colorscheme.
- `after/lsp/lua_ls.lua`: Lua LS config.

## Plugins / Features

- Finders: `mini.pick` + `mini.extra`.
- UI hints: `mini.clue`.
- Treesitter: `nvim-treesitter` (auto-installs common parsers).
- LSP: `nvim-lspconfig` with `lua_ls` and `gopls`.
- Formatting: `conform.nvim` with `stylua` for Lua.
- Theme: `kanso.nvim` (`zen`).
