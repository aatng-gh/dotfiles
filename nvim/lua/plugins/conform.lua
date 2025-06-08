return {
  "stevearc/conform.nvim",
  lazy = true,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format()
      end,
      desc = "Format",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      go = { "goimports", "gofumpt" },
    },
  },
}
