-- TODO: mini.clues

-- [[ Options ]] {{{
vim.g.nerd_font = true
vim.g.border_style = 'single'

vim.o.foldmethod = 'marker'
vim.o.foldlevel = 99

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- }}}

-- [[ Keymaps ]] {{{
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- }}}

-- [[ mini.nvim ]] {{{
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- }}}

-- [[ Deps ]] {{{
local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add('rose-pine/neovim')
add('stevearc/conform.nvim')
add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function()
      vim.cmd('TSUpdate')
    end,
  },
})
add('williamboman/mason.nvim')
-- }}}

-- [[ UI ]] {{{
now(function()
  require('rose-pine').setup({
    styles = {
      italic = false,
    },
  })
  vim.cmd.colorscheme('rose-pine')

  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
end)

now(function()
  vim.diagnostic.config({
    severity_sort = true,
    float = { border = vim.g.border_style, source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  })
end)
-- }}}

-- [[ Workflows ]] {{{
now(function()
  require('mini.basics').setup() -- TODO: read more
end)

later(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 5000 },
    WARN = { duration = 4000 },
    INFO = { duration = 3000 },
  })
end)

later(function()
  require('mini.indentscope').setup()
end)

later(function()
  local MiniPick = require('mini.pick')
  local MiniExtra = require('mini.extra')

  MiniPick.setup({ window = { config = { border = vim.g.border_style }, prompt_prefix = '{ ', prompt_caret = ' }' } })
  vim.ui.select = MiniPick.ui_select

  vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.buffers, { desc = '[S]earch [B]uffers' })
  vim.keymap.set('n', '<leader>sd', MiniExtra.pickers.diagnostic, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sf', MiniPick.builtin.files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sg', MiniPick.builtin.grep_live, { desc = 'Search by [G]rep' })
  vim.keymap.set('n', '<leader>sh', MiniPick.builtin.help, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sr', MiniPick.builtin.resume, { desc = 'Search Resume' })
  vim.keymap.set('n', '<leader>sw', MiniPick.builtin.grep, { desc = '[S]earch [W]ord' })
end)

later(function()
  local MiniSessions = require('mini.sessions')
  MiniSessions.setup()

  vim.keymap.set('n', '<leader>es', MiniSessions.select, { desc = 'S[e]ssion [S]elect' })
  vim.keymap.set('n', '<leader>er', function()
    MiniSessions.read()
  end, { desc = 'S[e]ssion [R]ead' })
  vim.keymap.set('n', '<leader>ew', function()
    MiniSessions.write()
  end, { desc = 'S[e]ssion [W]rite' })
  vim.keymap.set('n', '<leader>ed', function()
    MiniSessions.delete()
  end, { desc = 'S[e]ssion [D]elete' })
end)

later(function()
  local MiniHipatterns = require('mini.hipatterns')
  MiniHipatterns.setup({
    highlighters = {
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

      hex_color = MiniHipatterns.gen_highlighter.hex_color(),
    },
  })
end)
-- }}}

-- [[ LSP ]] {{{
now(function()
  vim.lsp.enable({ 'lua_ls', 'ts_ls' }) -- must always be loaded immediately
end)

later(function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'javascript', 'typescript', 'vimdoc' },
    auto_install = true,
    highlight = { enable = true },
  })
end)

later(function()
  require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false },
  })
end)

later(function()
  require('mason').setup()
end)

later(function()
  local Conform = require('conform')
  Conform.setup({
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'biome' },
      typescript = { 'biome' },
    },
  })

  vim.keymap.set('n', '<leader>f', function()
    Conform.format({ async = true, lsp_format = 'fallback' })
  end, { desc = '[F]ormat' })
end)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    local opts = { buffer = args.buf }

    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = vim.g.border_style })
    end, opts)
    vim.keymap.set('n', '<C-k>', function()
      vim.lsp.buf.signature_help({ border = vim.g.border_style })
    end, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- TODO: more pickers
  end,
})
-- }}}
