---@diagnostic disable: missing-fields

-- mini.deps {{{
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
-- }}}

local function options() -- {{{
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
  vim.o.shiftwidth = 4
  vim.o.tabstop = 4

  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)
end
-- }}}

local function keymaps() -- {{{
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
end
-- }}}

local function ui() -- {{{
  add('edeneast/nightfox.nvim')
  require('nightfox').setup()
  vim.cmd.colorscheme('nightfox')

  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

  vim.diagnostic.config({
    severity_sort = true,
    float = { border = vim.g.border, source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.nerd_font and {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    } or {},
    virtual_text = { source = 'if_many', spacing = 2 },
  })
end
-- }}}

local function hipatterns() -- {{{
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
-- }}}

local function notify() -- {{{
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 5000 },
    WARN = { duration = 4000 },
    INFO = { duration = 3000 },
  })
end
-- }}}

local function pick() -- {{{
  -- MiniPick
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

  vim.keymap.set('n', '<leader><leader>', mp.builtin.buffers, { desc = 'Search buffers' })
  vim.keymap.set('n', '<leader>sf', mp.builtin.files, { desc = 'Search files' })
  vim.keymap.set('n', '<leader>sg', mp.builtin.grep_live, { desc = 'Search by grep live' })
  vim.keymap.set('n', '<leader>sh', mp.builtin.help, { desc = 'Search help' })
  vim.keymap.set('n', '<leader>sr', mp.builtin.resume, { desc = 'Search resume' })

  -- MiniExtra
  local me = require('mini.extra')
  vim.keymap.set('n', '<leader>sd', me.pickers.diagnostic, { desc = 'Search diagnostics' })
  vim.keymap.set('n', '<leader>st', me.pickers.treesitter, { desc = 'Search treesitter' })
  vim.keymap.set('n', '<leader>sc', me.pickers.commands, { desc = 'Search commands' })

  -- MiniClue
  local mc = require('mini.clue')
  mc.setup({
    triggers = {
      { mode = 'n', keys = '<leader>' },
      { mode = 'n', keys = 'g' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
    },
    clues = {
      { mode = 'n', keys = '<leader>s', desc = '+Search' },
      { mode = 'n', keys = '<leader>g', desc = '+Git' },
      mc.gen_clues.g(),
      mc.gen_clues.windows(),
      mc.gen_clues.z(),
    },
  })
end
-- }}}

local function treesitter() -- {{{
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
-- }}}

local function conform() -- {{{
  add('stevearc/conform.nvim')
  local cf = require('conform')

  cf.setup({
    notify_on_error = true,
    notify_no_formatters = true,
    format_on_save = function(bufnr)
      local disabled = { c = true, cpp = true }
      if disabled[vim.bo[bufnr].filetype] then
        return nil
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'goimports', 'gofumpt' },
      python = { 'isort', 'black' },
      typescript = { 'prettierd' },
      javascript = { 'prettierd' },
      markdown = { 'markdownlint' },
      yaml = { 'yamlfmt' },
      json = { 'prettierd' },
      toml = { 'tombi' },
    },
  })

  vim.keymap.set('n', '<leader>f', function()
    cf.format({
      async = true,
      lsp_format = 'fallback',
    })
  end, { desc = 'Format' })
end
-- }}}

local function indentscope() -- {{{
  require('mini.indentscope').setup()
end
-- }}}

local function lsp() -- {{{
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

  vim.lsp.enable({ 'lua_ls', 'vtsls', 'gopls' })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buf = args.buf
      vim.bo[buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
      local map = function(keys, fn, desc)
        vim.keymap.set('n', keys, fn, { buffer = buf, desc = desc })
      end
      local me = require('mini.extra')

      -- hover & signature
      map('K', function()
        vim.lsp.buf.hover({ border = vim.g.border })
      end, 'Hover docs')
      map('<C-k>', function()
        vim.lsp.buf.signature_help({ border = vim.g.border })
      end, 'Signature help')

      -- go to & references
      map('grd', function()
        me.pickers.lsp({ scope = 'definition' })
      end, 'Go to definition')
      map('grD', function()
        me.pickers.lsp({ scope = 'declaration' })
      end, 'Go to declaration')
      map('gri', function()
        me.pickers.lsp({ scope = 'implementation' })
      end, 'Go to implementation')
      map('grt', function()
        me.pickers.lsp({ scope = 'type_definition' })
      end, 'Go to type definition')
      map('grr', function()
        me.pickers.lsp({ scope = 'references' })
      end, 'Go to references')

      -- diagnostics
      map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic')
      map(']d', function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, 'Next diagnostic')
      map('[d', function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, 'Prev diagnostic')
      map('<leader>q', vim.diagnostic.setloclist, 'Quickfix diagnostics')

      -- actions
      map('grn', vim.lsp.buf.rename, 'Rename symbol')
      map('gra', vim.lsp.buf.code_action, 'Code action')
    end,
  })
end
-- }}}

local function lint() -- {{{
  add('mfussenegger/nvim-lint')

  local l = require('lint')
  l.linters_by_ft = {
    lua = { 'selene' },
    go = { 'golangcilint' },
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

  vim.keymap.set('n', '<leader>l', l.try_lint, { desc = 'Lint' })
end
-- }}}

local function diff() -- {{
  local md = require('mini.diff')
  md.setup()

  vim.keymap.set('n', '<leader>go', md.toggle_overlay, { desc = 'Toggle diff overlay' })
end
-- }}}

local function sessions() -- {{{
  local ms = require('mini.sessions')

  ms.setup({
    autoread = true,
    autowrite = true,
    file = 'session.vim',
  })

  vim.keymap.set('n', '<leader>Sw', function()
    ms.write('session.vim')
  end, { desc = 'Write session' })
end
-- }}}

now(function()
  options()
  ui()
  keymaps()
  notify()
  sessions()
  lsp()
end)

later(function()
  lint()
  conform()
  treesitter()
  hipatterns()
  indentscope()
  pick()
  diff()
end)
