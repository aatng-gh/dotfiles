-- [[ Options ]] {{{
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
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
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
add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

-- }}}

-- [[ UI ]] {{{
now(function()
  require('rose-pine').setup({
    styles = {
      italic = false
    },
  })
  vim.cmd.colorscheme 'rose-pine'

  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 5000 },
    WARN = { duration = 4000 },
    INFO = { duration = 3000 },
  })

  require('mini.basics').setup() -- TODO: read more
  require('mini.indentscope').setup()
end)
-- }}}

-- [[ LSP ]] {{{
now(function()
  vim.diagnostic.config({
    severity_sort = true,
    float = { border = 'single', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
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

  vim.lsp.enable({ 'luals' }) -- should always be in now()
end)

later(function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    auto_install = true,
    highlight = { enable = true },
  })

  require('mini.completion').setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false }
  })

  local MiniPick = require('mini.pick')
  MiniPick.setup({ window = { config = { border = 'single' }, prompt_prefix = '{ ', prompt_caret = ' }' } })
end)

vim.api.nvim_create_autocmd('LspAttach', {
  -- group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    local MiniPick = require('mini.pick')
    local MiniExtra = require('mini.extra')


    local opts = { buffer = ev.buf }

    -- LSP
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
      vim.notify('Formatted')
    end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'single' }) end, opts)
    vim.keymap.set('n', '<C-k>', function() vim.lsp.buf.signature_help({ border = 'single' }) end, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    -- Pick/Extra
    vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.buffers, opts)
    vim.keymap.set('n', '<leader>sd', MiniExtra.pickers.diagnostic, opts)
    vim.keymap.set('n', '<leader>sf', MiniPick.builtin.files, opts)
    vim.keymap.set('n', '<leader>sg', MiniPick.builtin.grep_live, opts)
    vim.keymap.set('n', '<leader>sw', MiniPick.builtin.grep, opts)
  end,
})
-- }}}
