vim.o.clipboard = 'unnamedplus'
vim.g.backdrop = 100
vim.g.border = 'single'

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  end,
})

require('lazy').setup({
  spec = {
    {
      'rose-pine/neovim',
      name = 'rose-pine',
      priority = 99,
      opts = {
        styles = {
          italic = false,
        },
      },
      config = function(_, opts)
        require('rose-pine').setup(opts)
        vim.cmd.colorscheme('rose-pine')
      end,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'mason-org/mason.nvim', opts = {
          ui = { backdrop = vim.g.backdrop, border = vim.g.border },
        } },
      },
    },
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>f',
          function()
            require('conform').format({ async = true, lsp_format = 'fallback' })
          end,
          mode = '',
          desc = 'Format',
        },
      },
      opts = {
        notify_on_error = true,
        notify_no_formatters = true,
        format_on_save = function(bufnr)
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
        },
      },
    },
    {
      'folke/snacks.nvim',
      opts = {
        picker = {
          layout = {
            layout = {
              box = 'horizontal',
              backdrop = vim.g.backdrop,
              width = 0.8,
              min_width = 120,
              height = 0.8,
              {
                box = 'vertical',
                border = vim.g.border,
                title = '{title} {live} {flags}',
                { win = 'input', height = 1, border = 'bottom' },
                { win = 'list', border = 'none' },
              },
              { win = 'preview', title = '{preview}', border = vim.g.border, width = 0.5 },
            },
          },
        },
        explorer = {},
      },
      keys = {
        -- Top Pickers & Explorer
        {
          '<leader><space>',
          function()
            Snacks.picker.smart()
          end,
          desc = 'Smart Find Files',
        },
        {
          '<leader>,',
          function()
            Snacks.picker.buffers()
          end,
          desc = 'Buffers',
        },
        {
          '<leader>/',
          function()
            Snacks.picker.grep()
          end,
          desc = 'Grep',
        },
        {
          '<leader>:',
          function()
            Snacks.picker.command_history()
          end,
          desc = 'Command History',
        },
        {
          '<leader>n',
          function()
            Snacks.picker.notifications()
          end,
          desc = 'Notification History',
        },
        {
          '<leader>e',
          function()
            Snacks.explorer()
          end,
          desc = 'File Explorer',
        },
      },
    },
  },
  ui = {
    backdrop = vim.g.backdrop,
    border = vim.g.border,
  },
  checker = { enabled = true },
})
