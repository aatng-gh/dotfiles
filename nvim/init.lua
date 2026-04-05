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

local lsp_servers = { 'lua_ls', 'vtsls', 'gopls', 'basedpyright' }

local function globals()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
end

local function options()
    vim.o.mouse = 'a' -- enable mouse support

    vim.o.undofile = true -- persist undo history
    vim.o.swapfile = false -- disable swap files

    vim.o.signcolumn = 'yes' -- always show the sign column
    vim.o.number = true -- show absolute line numbers
    vim.o.relativenumber = true -- show relative line numbers
    vim.o.breakindent = true -- preserve indentation on wrapped lines
    vim.o.wrap = true -- wrap long lines

    vim.o.clipboard = 'unnamedplus' -- use the system clipboard

    vim.o.list = true -- show invisible characters
    vim.o.listchars = 'tab:» ,trail:·,nbsp:␣' -- define invisible character symbols

    vim.o.inccommand = 'split' -- preview substitutions in a split
    vim.o.cursorline = true -- highlight the current line

    vim.o.tabstop = 4 -- render tabs as four spaces
    vim.o.shiftwidth = 4 -- indent by four spaces
    vim.o.expandtab = true -- insert spaces instead of tabs
    vim.o.textwidth = 80 -- wrap text at eighty columns
    vim.o.smartindent = true -- enable basic autoindenting

    vim.o.hlsearch = true -- highlight search matches
    vim.o.incsearch = true -- update matches while typing

    vim.o.autocomplete = true -- enable automatic completion
    vim.o.completeopt = 'menu,menuone,noselect,nearest' -- for manual completion, show the menu, keep a single-item menu, avoid preselecting, and prefer nearby matches
end

local function diagnostics()
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = ' ',
                [vim.diagnostic.severity.WARN] = ' ',
                [vim.diagnostic.severity.INFO] = ' ',
                [vim.diagnostic.severity.HINT] = ' ',
            },
        },
        severity_sort = true,
        virtual_text = true, -- show inline diagnostics
    })
end

local function keymaps()
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'diagnostics' })
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, { desc = 'format' })
end

local function plugins()
    vim.pack.add({
        'https://github.com/nvim-mini/mini.nvim',
        { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    })
end

local function treesitter()
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
end

local function autocmds()
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local filetype = vim.bo[args.buf].filetype
            local lang = vim.treesitter.language.get_lang(filetype)
            if not lang then
                return
            end

            local ok = pcall(vim.treesitter.start, args.buf, lang)
            if ok then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            if client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            end
        end,
    })
end

local function lsp()
    vim.lsp.enable(lsp_servers)
end

globals()
options()
diagnostics()
keymaps()
plugins()
treesitter()
autocmds()
lsp()
