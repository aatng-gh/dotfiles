vim.g.mapleader = ' ' -- use <space> as leader

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
