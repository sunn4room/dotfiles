return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = true,
  opts = {
    adapters = {},
    status = {
      enabled = true,
      signs = false,
      virtual_text = true,
    },
  },
  specs = {
    "sunn4room/common.nvim",
    opts = {
      mappings = {
        n = {
          ["<cr>z"] = {
            callback = function()
              require("neotest").run.run()
            end,
            desc = "test",
          },
          ["<cr>Z"] = {
            callback = function()
              require("neotest").run.run { strategy = "dap" }
            end,
            desc = "test",
          },
        },
      },
      highlights = {
        NeotestRunning = { fg = 6 },
        NeotestFailed = { fg = 1 },
        NeotestPassed = { fg = 2 },
        NeotestSkipped = { fg = 4 },
      },
    },
  },
}
