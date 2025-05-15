local add, now, later

-- deps {{{
local function deps()
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
end
-- }}}

local function options() -- {{{
  require('mini.basics').setup()
  vim.g.nerd_font = true
  vim.g.border_style = 'single'

  vim.opt.list = true
  vim.opt.listchars = {
    tab = '» ',
    trail = '·',
    extends = '>',
    precedes = '<',
    nbsp = '␣',
  }

  vim.o.foldmethod = 'marker'
  vim.o.foldlevel = 99

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
  add('rose-pine/neovim')
  require('rose-pine').setup({ styles = { italic = false } })
  vim.cmd.colorscheme('rose-pine')

  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

  vim.diagnostic.config({
    severity_sort = true,
    float = { border = vim.g.border_style, source = 'if_many' },
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

local function pickers() -- {{{
  local mp = require('mini.pick')
  local me = require('mini.extra')

  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = 'NW',
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
      border = vim.g.border_style,
    }
  end

  mp.setup({
    window = {
      config = win_config,
      prompt_caret = '▁',
      prompt_prefix = ' ',
    },
  })

  vim.ui.select = mp.ui_select

  -- MiniPick
  vim.keymap.set('n', '<leader><leader>', mp.builtin.buffers, { desc = 'Search Buffers' })
  vim.keymap.set('n', '<leader>sf', mp.builtin.files, { desc = 'Search Files' })
  vim.keymap.set('n', '<leader>sg', mp.builtin.grep_live, { desc = 'Search by Grep Live' })
  vim.keymap.set('n', '<leader>sw', mp.builtin.grep, { desc = 'Search Word' })
  vim.keymap.set('n', '<leader>sh', mp.builtin.help, { desc = 'Search Help' })
  vim.keymap.set('n', '<leader>sr', mp.builtin.resume, { desc = 'Search Resume' })

  -- MiniExtra
  vim.keymap.set('n', '<leader>sd', me.pickers.diagnostic, { desc = 'Search Diagnostics' })
  vim.keymap.set('n', '<leader>st', me.pickers.treesitter, { desc = 'Search Treesitter' })
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
    ensure_installed = { 'lua', 'javascript', 'typescript', 'vimdoc' },
    auto_install = true,
    highlight = { enable = true },
  })
end
-- }}}

local function conform() -- {{{
  add('stevearc/conform.nvim')
  local cf = require('conform')

  cf.setup({
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disabled = { c = true, cpp = true }
      if disabled[vim.bo[bufnr].filetype] then
        return nil
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      go = { 'goimports', 'gofumpt' },
    },
  })

  vim.keymap.set('n', '<leader>f', function()
    cf.format({ async = true, lsp_format = 'fallback' })
    vim.notify('Formatted', vim.log.levels.INFO)
  end, { desc = '[F]ormat' })
end
-- }}}

local function indentscope() -- {{{
  require('mini.indentscope').setup()
end
-- }}}

local function sessions() -- {{{
  local ms = require('mini.sessions')
  ms.setup()

  vim.keymap.set('n', '<leader>es', ms.select, { desc = 'Session Select' })
  vim.keymap.set('n', '<leader>er', ms.read, { desc = 'Session Read' })
  vim.keymap.set('n', '<leader>ew', ms.write, { desc = 'Session Write' })
  vim.keymap.set('n', '<leader>ed', ms.delete, { desc = 'Session Delete' })
end
-- }}}

local function lsp() -- {{{
  add('williamboman/mason.nvim')
  require('mason').setup()
  add('neovim/nvim-lspconfig')

  vim.lsp.enable({ 'lua_ls', 'ts_ls', 'gopls' }) -- after Mason

  require('mini.completion').setup({ lsp_completion = { source_func = 'omnifunc', auto_setup = false } })

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
        vim.lsp.buf.hover({ border = vim.g.border_style })
      end, 'Hover Docs')
      map('<C-k>', function()
        vim.lsp.buf.signature_help({ border = vim.g.border_style })
      end, 'Signature Help')

      -- go to & references
      map('gd', vim.lsp.buf.definition, 'Go to Definition')
      map('gi', vim.lsp.buf.implementation, 'Go to Implementation')
      map('gt', vim.lsp.buf.type_definition, 'Go to Type Definition')
      map('gr', vim.lsp.buf.references, 'Go to References')

      -- diagnostics
      map('<leader>e', vim.diagnostic.open_float, 'Show Diagnostic')
      map(']d', function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, 'Next Diagnostic')
      map('[d', function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, 'Prev Diagnostic')
      map('<leader>q', vim.diagnostic.setloclist, 'Quickfix Diagnostics')

      -- actions
      map('<leader>rn', vim.lsp.buf.rename, 'Rename')
      map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

      -- symbols
      map('<leader>ds', function()
        me.pickers.lsp({ scope = 'document_symbol' })
      end, '[D]ocument [S]ymbol')
      map('<leader>ws', function()
        me.pickers.lsp({ scope = 'workspace_symbol' })
      end, '[W]orkspace [S]ymbol')
    end,
  })
end

-- }}}

deps()

now(function()
  options()
  keymaps()
  notify()
  ui()
  lsp()
end)

later(function()
  pickers()
  treesitter()
  hipatterns()
  conform()
  indentscope()
  sessions()
end)
