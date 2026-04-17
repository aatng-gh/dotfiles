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

-- Treesitter
require('nvim-treesitter').install({
  'bash',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'tsx',
  'typescript',
  'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  callback = function(ev)
    vim.treesitter.start(ev.buf)
  end,
})

-- LSP
vim.lsp.enable({ 'lua_ls', 'vtsls' })

-- Keymaps
vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format' })

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('n', 'gY', '"+Y', { desc = 'Copy line to clipboard' })

local pick = require('mini.pick')
pick.setup()
local extra = require('mini.extra')
extra.setup()
require('mini.clue').setup({
  triggers = {
    { mode = 'n', keys = '<leader>' },
    { mode = 'n', keys = 'g' },
  },
  clues = {
    { mode = 'n', keys = '<leader>b', desc = '+Buffers' },
    { mode = 'n', keys = '<leader>f', desc = '+Find' },
    { mode = 'n', keys = '<leader>l', desc = '+Language' },
    { mode = 'n', keys = '<leader>t', desc = '+Tabs' },
    { mode = 'n', keys = 'g', desc = '+Go' },
  },
})

vim.keymap.set('n', '<leader>fb', pick.builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>ff', pick.builtin.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live, { desc = 'Find by grep' })
vim.keymap.set('n', '<leader>fh', pick.builtin.help, { desc = 'Find help' })
vim.keymap.set('n', '<leader>fk', extra.pickers.keymaps, { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>fr', pick.builtin.resume, { desc = 'Find resume' })

vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close tab' })
