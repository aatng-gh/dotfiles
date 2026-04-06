local treesitter_languages = {
    'lua',
    'vim',
    'vimdoc',
    'query',
    'go',
    'python',
    'javascript',
    'typescript',
}

vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

local ts = require('nvim-treesitter')

ts.setup({})

local installed = ts.get_installed()
local missing = {}
for _, lang in ipairs(treesitter_languages) do
    if not vim.tbl_contains(installed, lang) then
        table.insert(missing, lang)
    end
end

if #missing > 0 then
    ts.install(missing)
end

local lsp_servers = { 'lua_ls', 'vtsls', 'gopls', 'basedpyright' }

vim.lsp.enable(lsp_servers)
