vim.filetype.add {
  extension = {
    http = "http",
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        http = true,
      },
    },
  },
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {
      default_view = "headers_body",
      icons = {
        inlay = {
          loading = "…",
          done = "✔",
          error = "✘",
        },
      },
    },
  },
}
