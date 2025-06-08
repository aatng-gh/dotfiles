return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  opts = {

    highlight = {
      enable = true,
      use_languagetree = true,
    },
    indent = { enable = true },
  },
}
