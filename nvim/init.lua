---@diagnostic disable: missing-fields

-- [[ Bootstrap ]]
local add, now, later
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })
add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- [[ Options ]]
local function options()
  require('mini.basics').setup()

  vim.g.nerd_font = true
  vim.g.backdrop = 100
  vim.g.border = 'single'

  vim.opt.list = true
  vim.opt.listchars = {
    tab = '» ',
    trail = '·',
    extends = '>',
    precedes = '<',
    nbsp = '␣',
  }

  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldtext = ''
  vim.o.foldlevel = 99
  vim.o.foldnestmax = 4

  vim.o.expandtab = true

  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)

  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
end

-- [[ UI ]]
local function ui()
  add('webhooked/kanso.nvim')
  require('kanso').setup({ italics = false })
  vim.cmd.colorscheme('kanso-zen')

  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

  vim.diagnostic.config({
    severity_sort = true,
    float = { border = vim.g.border, source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = { source = 'if_many', spacing = 2 },
  })
end

-- [[ Treesitter ]]
local function treesitter()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = function()
        vim.cmd('TSUpdate')
      end,
    },
  })

  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'go', 'javascript', 'typescript', 'vimdoc' },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = { enable = true },
  })
end

-- [[ LSP ]]
local function lsp()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = {
      'mason-org/mason.nvim',
      'folke/lazydev.nvim',
    },
  })

  require('mason').setup({
    ui = {
      backdrop = vim.g.backdrop,
      border = vim.g.border,
    },
  })

  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  })

  require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false },
  })

  vim.lsp.enable({ 'lua_ls', 'vtsls', 'gopls', 'pyright' })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.g.border })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = vim.g.border })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buf = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      vim.bo[buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

      local map = function(keys, fn, desc)
        vim.keymap.set('n', keys, fn, { buffer = buf, desc = desc })
      end
      local me = require('mini.extra')

      -- Inlay hints
      if client and client:supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        map('<leader>lh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
        end, 'Inlay hints (toggle)')
      end

      -- LSP pickers
      map('<leader>ld', function()
        me.pickers.lsp({ scope = 'definition' })
      end, 'Definition')
      map('<leader>lD', function()
        me.pickers.lsp({ scope = 'declaration' })
      end, 'Declaration')
      map('<leader>li', function()
        me.pickers.lsp({ scope = 'implementation' })
      end, 'Implementation')
      map('<leader>lt', function()
        me.pickers.lsp({ scope = 'type_definition' })
      end, 'Type definition')
      map('<leader>lr', function()
        me.pickers.lsp({ scope = 'references' })
      end, 'References')
      map('<leader>ls', function()
        me.pickers.lsp({ scope = 'document_symbol' })
      end, 'Symbols')

      -- Diagnostics
      map('<leader>le', vim.diagnostic.open_float, 'Diagnostic')
      map(']d', function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, 'Next diagnostic')
      map('[d', function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, 'Prev diagnostic')
      map('<leader>lq', vim.diagnostic.setloclist, 'Quickfix')
    end,
  })
end

-- [[ Sessions ]]
local function sessions()
  local ms = require('mini.sessions')

  ms.setup({
    autoread = true,
    autowrite = true,
    file = 'session.vim',
  })

  vim.keymap.set('n', '<leader>ss', function()
    ms.select('read')
  end, { desc = 'Select' })
  vim.keymap.set('n', '<leader>sw', function()
    ms.select('write')
  end, { desc = 'Write' })
  vim.keymap.set('n', '<leader>sd', function()
    ms.select('delete')
  end, { desc = 'Delete' })
end

-- [[ Pick ]]
local function pick()
  local mp = require('mini.pick')

  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = 'NW',
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
      border = vim.g.border,
    }
  end

  mp.setup({
    window = {
      config = win_config,
      prompt_prefix = '› ',
      prompt_caret = '▁',
    },
  })

  vim.ui.select = mp.ui_select

  -- Quick access
  vim.keymap.set('n', '<leader><space>', mp.builtin.files, { desc = 'Files' })
  vim.keymap.set('n', '<leader>,', mp.builtin.buffers, { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>/', mp.builtin.grep_live, { desc = 'Grep' })

  -- Find group
  vim.keymap.set('n', '<leader>fb', mp.builtin.buffers, { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>ff', mp.builtin.files, { desc = 'Files' })
  vim.keymap.set('n', '<leader>fg', mp.builtin.grep_live, { desc = 'Grep' })
  vim.keymap.set('n', '<leader>fh', mp.builtin.help, { desc = 'Help' })
  vim.keymap.set('n', '<leader>fr', mp.builtin.resume, { desc = 'Resume' })

  -- MiniExtra pickers
  local me = require('mini.extra')
  vim.keymap.set('n', '<leader>fo', me.pickers.oldfiles, { desc = 'Old files' })
  vim.keymap.set('n', '<leader>fd', me.pickers.diagnostic, { desc = 'Diagnostics' })
  vim.keymap.set('n', '<leader>ft', me.pickers.treesitter, { desc = 'Treesitter' })
  vim.keymap.set('n', '<leader>fc', me.pickers.commands, { desc = 'Commands' })
  vim.keymap.set('n', '<leader>fk', me.pickers.keymaps, { desc = 'Keymaps' })
  vim.keymap.set('n', '<leader>fm', me.pickers.marks, { desc = 'Marks' })
  vim.keymap.set('n', '<leader>f"', me.pickers.registers, { desc = 'Registers' })
  vim.keymap.set('n', '<leader>f:', me.pickers.history, { desc = 'Command history' })
  vim.keymap.set('n', '<leader>f.', me.pickers.buf_lines, { desc = 'Buffer lines' })
end

-- [[ Clue ]]
local function clue()
  local mc = require('mini.clue')
  mc.setup({
    triggers = {
      { mode = 'n', keys = '<leader>' },
      { mode = 'n', keys = 'g' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
    },
    clues = {
      { mode = 'n', keys = '<leader>f', desc = '+Find' },
      { mode = 'n', keys = '<leader>g', desc = '+Git' },
      { mode = 'n', keys = '<leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<leader>s', desc = '+Session' },
      mc.gen_clues.g(),
      mc.gen_clues.windows(),
      mc.gen_clues.z(),
    },
  })
end

-- [[ Conform ]]
local function conform()
  add('stevearc/conform.nvim')
  local cf = require('conform')

  cf.setup({
    notify_on_error = true,
    notify_no_formatters = true,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'goimports', 'gofumpt' },
      python = { 'isort', 'ruff' },
      typescript = { 'prettierd' },
      javascript = { 'prettierd' },
      markdown = { 'markdownlint' },
      yaml = { 'yamlfmt' },
      json = { 'prettierd' },
      toml = { 'tombi' },
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
    cf.format({
      async = true,
      lsp_format = 'fallback',
    })
  end, { desc = 'Format' })
end

-- [[ Lint ]]
local function lint()
  add('mfussenegger/nvim-lint')

  local l = require('lint')
  l.linters_by_ft = {
    lua = { 'selene' },
    go = { 'golangcilint' },
    python = { 'ruff' },
    typescript = { 'eslint_d' },
    javascript = { 'eslint_d' },
    markdown = { 'markdownlint' },
    yaml = { 'yamllint' },
  }

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    callback = function()
      local filetype = vim.bo.filetype
      if l.linters_by_ft[filetype] then
        l.try_lint()
      end
    end,
  })

  vim.keymap.set('n', '<leader>ll', l.try_lint, { desc = 'Lint' })
end

-- [[ Diff ]]
local function diff()
  local md = require('mini.diff')
  md.setup()

  vim.keymap.set('n', '<leader>gd', md.toggle_overlay, { desc = 'Diff (toggle)' })
end

-- [[ Notify ]]
local function notify()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 5000 },
    WARN = { duration = 4000 },
    INFO = { duration = 3000 },
  })
end

-- [[ Hipatterns ]]
local function hipatterns()
  local hi = require('mini.hipatterns')
  hi.setup({
    highlighters = {
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
      hex_color = hi.gen_highlighter.hex_color(),
    },
  })
end

-- [[ Indentscope ]]
local function indentscope()
  require('mini.indentscope').setup()
end

-- [[ Guess Indent ]]
local function guessindent()
  add('nmac427/guess-indent.nvim')
  require('guess-indent').setup({})
end

-- [[ Load ]]
now(function()
  options()
  ui()
  treesitter()
  pick()
  sessions()
  lsp()
end)

later(function()
  clue()
  notify()
  conform()
  lint()
  diff()
  hipatterns()
  indentscope()
  guessindent()
end)
