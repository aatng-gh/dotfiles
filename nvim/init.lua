vim.g.mapleader = ' '
vim.g.maplocalleader = '//'
vim.g.backdrop = 100
vim.g.border = 'single'

vim.o.clipboard = 'unnamedplus'
vim.o.number = true
vim.o.foldmethod = 'marker'
vim.o.foldlevelstart = 99

-- Lazy {{{
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
-- }}}

local function autocmds() -- {{{
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
    end,
  })

  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
  })
end
-- }}}

autocmds()

require('lazy').setup({
  spec = {
    {
      'rose-pine/neovim',
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
          '<leader>lf',
          function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
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
        { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
        { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
        { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
        { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
        { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },

        -- Find
        { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = 'Find Config File' },
        { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
        { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
        { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
        { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },

        -- Git
        { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
        { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
        { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
        { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
        { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
        { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
        { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },

        -- Grep
        { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
        { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
        { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
        { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },

        -- Search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
        { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
        { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
        { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History' },
        { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands' },
        { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
        { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
        { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
        { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
        { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
        { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
        { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
        { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
        { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
        { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages' },
        { '<leader>sp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
        { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
        { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume' },
        { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
        { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },

        -- LSP
        { 'grd', function() Snacks.picker.lsp_definitions() end, desc = 'Go to Definition' },
        { 'grD', function() Snacks.picker.lsp_declarations() end, desc = 'Go to Declaration' },
        { 'grr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
        { 'gri', function() Snacks.picker.lsp_implementations() end, desc = 'Go to Implementation' },
        { 'grt', function() Snacks.picker.lsp_type_definitions() end, desc = 'Go to Type Definition' },
        { '<leader>ls', function() Snacks.picker.lsp_symbols() end, desc = 'Document Symbols' },
        { '<leader>lS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Workspace Symbols' },
      },
    },
  },
  ui = {
    backdrop = vim.g.backdrop,
    border = vim.g.border,
  },
  checker = { enabled = true },
})
