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
    "sunn4room/httpc.nvim",
    -- dir = vim.env.HOME .. "/Projects/httpc.nvim",
    opts = {
      animation = {
        spinner = {
          {
            { ">", "Comment" },
            { ">", "Comment" },
            { ">", "Comment" },
          },
          {
            { ">", "Special" },
            { ">", "Comment" },
            { ">", "Comment" },
          },
          {
            { ">", "Comment" },
            { ">", "Special" },
            { ">", "Comment" },
          },
          {
            { ">", "Comment" },
            { ">", "Comment" },
            { ">", "Special" },
          },
        },
        interval = 200,
      },
    },
  },
}
