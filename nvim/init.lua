vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true

vim.opt.signcolumn = 'yes'

vim.opt.cursorline = true

vim.o.expandtab = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- mini.deps
local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Colorscheme
add({
  source = 'ayu-theme/ayu-vim',
})

now(function()
  vim.cmd.colorscheme 'ayu'
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = 'none' })
end)

-- Treesitter
add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

now(function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    auto_install = true,
    highlight = { enable = true },
  })
end)

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    -- TODO: keymaps
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'LSP Format', buffer = ev.buf })

    local pickers = require('mini.extra').pickers

    vim.keymap.set('n', '<leader>sd', pickers.diagnostic, { desc = 'Show Diagnostics' })

    vim.keymap.set('n', '<leader>sk', pickers.keymaps, { desc = 'Show Keymaps' })

    vim.keymap.set('n', 'gd', function()
      pickers.lsp({ scope = 'definition' })
    end, { desc = 'LSP: Go to Definition' })

    vim.keymap.set('n', 'gD', function()
      pickers.lsp({ scope = 'declaration' })
    end, { desc = 'LSP: Go to Declaration' })

    vim.keymap.set('n', 'gi', function()
      pickers.lsp({ scope = 'implementation' })
    end, { desc = 'LSP: Go to Implementation' })

    vim.keymap.set('n', 'gr', function()
      pickers.lsp({ scope = 'references' })
    end, { desc = 'LSP: References' })

    vim.keymap.set('n', '<leader>ds', function()
      pickers.lsp({ scope = 'document_symbol' })
    end, { desc = 'LSP: Document Symbols' })

    vim.keymap.set('n', '<leader>ws', function()
      pickers.lsp({ scope = 'workspace_symbol' })
    end, { desc = 'LSP: Workspace Symbols' })
  end,
})

vim.lsp.enable('luals')

-- Picker
later(function()
  require('mini.pick').setup()
  require('mini.extra').setup()
end)
