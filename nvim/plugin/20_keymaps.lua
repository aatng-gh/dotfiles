_G.Config.leader_clues = {
  { mode = 'n', keys = '<leader>l', desc = '+Language' },
}

vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Actions' })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Diagnostic popup' })
vim.keymap.set('n', '<leader>lf', function()
  require('conform').format()
end, { desc = 'Format' })
vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, { desc = 'Implementation' })
vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, { desc = 'Hover' })
vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>lR', vim.lsp.buf.references, { desc = 'References' })
vim.keymap.set('n', '<leader>ls', vim.lsp.buf.definition, { desc = 'Source definition' })
vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, { desc = 'Type definition' })
