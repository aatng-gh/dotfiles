return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.stylua.toml',
  },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
          vim.api.nvim_get_runtime_file('', true),
        },
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
