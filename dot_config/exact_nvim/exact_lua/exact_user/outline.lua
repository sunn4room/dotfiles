return {
  "hedyhli/outline.nvim",
  cmd = "Outline",
  opts = {
    outline_window = {
      width = 35,
      relative_width = false,
      auto_close = true,
    },
    keymaps = {
      goto_location = "o",
      peek_location = "O",
    },
  },
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>o"] = { command = "<cmd>Outline<cr>", desc = "outline" },
          },
        },
      },
    },
  },
}
