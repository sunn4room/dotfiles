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
    ft = "http",
    opts = {
      register = "r",
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
    specs = {
      {
        "sunn4room/common.nvim",
        opts = {
          commands = {
            Httpc = { callback = function() require("httpc").run() end },
            Httpcx = { callback = function() require("httpc").cancel() end },
          },
        },
      },
    },
  },
}
