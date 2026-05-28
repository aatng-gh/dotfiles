-- Plugins
vim.pack.add({
  'https://github.com/oxy2dev/markview.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}, { load = true })

-- Plugin setup
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

require('markview').setup({
  preview = {
    enable = true,
    icon_provider = 'internal',
    modes = { 'n', 'no', 'c', 'i', 'ic', 'v', 'V' },
    hybrid_modes = { 'i', 'ic' },
  },
})

local extra = require('mini.extra')
extra.setup()
local files = require('mini.files')
files.setup()
local diff = require('mini.diff')
diff.setup()
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
local pick = require('mini.pick')
pick.setup()
require('mini.clue').setup({
  triggers = {
    { mode = 'n', keys = '<leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
  },
  clues = {
    { mode = 'n', keys = '<leader>b', desc = '+Buffers' },
    { mode = 'n', keys = '<leader>f', desc = '+Find' },
    { mode = 'n', keys = '<leader>g', desc = '+Git' },
    { mode = 'n', keys = '<leader>l', desc = '+Language' },
    { mode = 'n', keys = '<leader>m', desc = '+Markdown' },
    { mode = 'n', keys = '<leader>t', desc = '+Tabs' },
    { mode = 'n', keys = 'g', desc = '+Go' },
  },
})

-- Options
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
})

-- Treesitter
require('nvim-treesitter').install({
  'bash',
  'go',
  'gomod',
  'gotmpl',
  'gowork',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'tsx',
  'typescript',
  'yaml',
})

-- LSP
vim.lsp.enable({ 'basedpyright', 'gopls', 'lua_ls', 'vtsls' })

-- Autocommands
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_completion', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client:supports_method('textDocument/definition') then
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Definition' })
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markview_keymap', { clear = true }),
  pattern = 'markdown',
  callback = function(ev)
    vim.keymap.set('n', '<leader>mp', '<cmd>Markview toggle<cr>', {
      buffer = ev.buf,
      desc = 'Toggle markdown render',
    })
    vim.keymap.set('n', '<leader>ms', '<cmd>Markview splitToggle<cr>', {
      buffer = ev.buf,
      desc = 'Toggle markdown split preview',
    })
  end,
})

-- Keymaps
vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format' })

vim.keymap.set('n', '<leader>e', function()
  if files.close() then
    return
  end

  local path = vim.api.nvim_buf_get_name(0)
  files.open(path ~= '' and path or nil, false)
end, { desc = 'File explorer' })

vim.keymap.set('n', '<leader>fb', pick.builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>ff', pick.builtin.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live, { desc = 'Find by grep' })
vim.keymap.set('n', '<leader>fh', pick.builtin.help, { desc = 'Find help' })
vim.keymap.set('n', '<leader>fk', extra.pickers.keymaps, { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>fr', pick.builtin.resume, { desc = 'Find resume' })

vim.keymap.set('n', '<leader>go', diff.toggle_overlay, { desc = 'Git overlay' })

vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close tab' })
