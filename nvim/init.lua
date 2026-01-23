local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    '--branch', 'stable',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.add

now(function()
  add('webhooked/kanso.nvim')
  require('kanso').setup({ italics = false })
  vim.cmd.colorscheme('kanso-zen')
end)

now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })

  local ts = require('nvim-treesitter')
  local installed = ts.get_installed()

  local wanted = { 'lua', 'go', 'typescript', 'javascript', 'python' }
  local missing = {}

  for _, lang in ipairs(wanted) do
    if not vim.tbl_contains(installed, lang) then
      table.insert(missing, lang)
    end
  end

  if #missing > 0 then
    ts.install(missing)
  end
end)
