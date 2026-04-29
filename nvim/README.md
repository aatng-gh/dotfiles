# Neovim Config

Minimal config using [mini.nvim](https://github.com/echasnovski/mini.nvim), nvim-treesitter, and Neovim's built-in LSP client.

## Keymaps

### Files

| Key | Action |
|-----|--------|
| `<leader>e` | File explorer |

### Find (`<leader>f`)

| Key | Action |
|-----|--------|
| `<leader>fb` | Buffers |
| `<leader>ff` | Files |
| `<leader>fg` | Grep |
| `<leader>fh` | Help |
| `<leader>fk` | Keymaps |
| `<leader>fr` | Resume |

### Buffers

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete buffer |

### LSP

| Key | Action |
|-----|--------|
| `<leader>lf` | Format |
| `gd` | Definition (LSP buffers) |

### Clipboard

| Key | Action |
|-----|--------|
| `gy` | Copy to clipboard |
| `gY` | Copy line to clipboard |

### Tabs

| Key | Action |
|-----|--------|
| `<leader>tn` | New tab |
| `<leader>tc` | Close tab |

### LSP (Neovim 0.12 defaults)

| Key | Action |
|-----|--------|
| `K` | Hover |
| `gra` | Code action |
| `gri` | Implementation |
| `grn` | Rename |
| `grr` | References |
| `grt` | Type definition |
| `grx` | Run codelens |
| `gO` | Document symbols |
| `<C-s>` | Signature help (insert mode) |

### Diagnostics (Neovim 0.12 defaults)

| Key | Action |
|-----|--------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `]D` | Last diagnostic |
| `[D` | First diagnostic |
| `<C-w>d` | Diagnostic at cursor |
