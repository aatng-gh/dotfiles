local MiniFiles = require 'mini.files'

-- Define the toggle function
local minifiles_toggle = function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end

return {
  'echasnovski/mini.files',
  version = '*',
  keys = {
    { '\\', minifiles_toggle, { desc = 'Toggle Mini.Files' } },
  },
  opts = {
    content = {
      filter = nil,
      prefix = nil,
      sort = nil,
    },
    mappings = {
      close = 'q',
      go_in = 'l',
      go_in_plus = 'L',
      go_out = 'h',
      go_out_plus = 'H',
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '=',
      trim_left = '<',
      trim_right = '>',
    },
    options = {
      permanent_delete = true,
      use_as_default_explorer = true,
    },
  },
}
