-- Plugins
vim.pack.add({
  'https://github.com/nvim-mini/mini.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

-- Basics
require('mini.basics').setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = 'single',
  },
  autocommands = {
    basic = true,
  },
})

-- Options
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autocomplete = true

-- Autocommands
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_completion', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- LSP
vim.lsp.enable({ 'lua_ls', 'vtsls' })

-- Keymaps
vim.keymap.set('n', '<leader>f', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format' })

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('n', 'gY', '"+Y', { desc = 'Copy line to clipboard' })

local pick = require('mini.pick')
pick.setup()
local extra = require('mini.extra')
extra.setup()

vim.keymap.set('n', '<leader>fb', pick.builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>ff', pick.builtin.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live, { desc = 'Find grep' })
vim.keymap.set('n', '<leader>fh', pick.builtin.help, { desc = 'Find help' })
vim.keymap.set('n', '<leader>fk', extra.pickers.keymaps, { desc = 'Find keymap' })
vim.keymap.set('n', '<leader>fr', pick.builtin.resume, { desc = 'Find resume' })
