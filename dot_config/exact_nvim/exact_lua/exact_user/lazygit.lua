return {
  "sunn4room/common.nvim",
  opts = {
    mappings = {
      n = {
        ["<cr>g"] = { command = "<cmd>tabnew term://lazygit<cr>i", desc = "lazygit" },
      },
    },
    autocmds = {
      autoclose_lazygit = {
        {
          event = "TermClose",
          pattern = "term://*:lazygit",
          callback = function()
            vim.api.nvim_input("<CR>")
          end,
        },
      },
    },
  },
}
