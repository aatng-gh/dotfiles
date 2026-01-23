local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add('webhooked/kanso.nvim')
  require('kanso').setup({ theme = 'zen' })
  vim.cmd("colorscheme kanso")
end)
