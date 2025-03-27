return {
  "goolord/alpha-nvim",
  opts = {
    opts = {
      setup = function()
        vim.keymap.set("n", "i", "<cmd>enew<cr>i", { buffer = true })
        vim.keymap.set("n", "a", "<cmd>enew<cr>i", { buffer = true })
        vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true })
      end,
    },
    layout = {
      { type = "padding", val = 6 },
      {
        type = "text",
        val = {
          "     ____                ____               ",
          "    /  _/_______________/ . /_____________  ",
          "   /_  / / /   /   / / /   / . / . /     /  ",
          "  /___/___/_/_/_/_/_  /_/_/___/___/_/_/_/   ",
          "                 /___/                      ",
        },
        opts = {
          position = "center",
          hl = "Keyword",
        },
      },
      { type = "padding", val = 2 },
      {
        type = "text",
        val = function()
          local stats = require("lazy.stats").stats()
          return {
            string.format(
              "lazy.nvim startup in %.3f ms",
              stats.times.LazyDone - stats.times.LazyStart
            ),
          }
        end,
        opts = {
          position = "center",
          hl = "Comment",
        },
      },
      { type = "padding", val = 6 },
    },
  },
}
