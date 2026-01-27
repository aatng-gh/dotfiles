local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    hooks = {
      post_checkout = function()
        vim.cmd('TSUpdate')
      end,
    },
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

now(function()
  add('neovim/nvim-lspconfig')
  vim.lsp.enable({ 'gopls', 'lua_ls', 'vtsls' })
end)

later(function()
  add('stevearc/conform.nvim')
  require('conform').setup({
    default_format_opts = { lsp_format = 'fallback' },
    formatters_by_ft = { lua = { 'stylua' } },
  })
end)

now(function()
  add('webhooked/kanso.nvim')
  require('kanso').setup({ theme = 'zen' })
  vim.cmd('colorscheme kanso')
end)
