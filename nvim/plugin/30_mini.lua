local now, later = MiniDeps.now, MiniDeps.later

later(function()
  require('mini.pick').setup()
  require('mini.extra').setup()
end)

later(function()
  local mc = require('mini.clue')
  mc.setup({
    clues = {
      Config.leader_clues,
      mc.gen_clues.builtin_completion(),
      mc.gen_clues.g(),
      mc.gen_clues.marks(),
      mc.gen_clues.registers(),
      mc.gen_clues.square_brackets(),
      mc.gen_clues.windows({ submode_resize = true }),
      mc.gen_clues.z(),
    },
    triggers = {
      { mode = { 'n', 'x' }, keys = '<leader>' }, -- Leader triggers
      { mode = 'n', keys = '\\' }, -- mini.basics
      { mode = { 'n', 'x' }, keys = '[' }, -- mini.bracketed
      { mode = { 'n', 'x' }, keys = ']' },
      { mode = 'i', keys = '<C-x>' }, -- Built-in completion
      { mode = { 'n', 'x' }, keys = 'g' }, -- `g` key
      { mode = { 'n', 'x' }, keys = "'" }, -- Marks
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' }, -- Registers
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' }, -- Window commands
      { mode = { 'n', 'x' }, keys = 's' }, -- `s` key (mini.surround, etc.)
      { mode = { 'n', 'x' }, keys = 'z' }, -- `z` key
    },
  })
end)
