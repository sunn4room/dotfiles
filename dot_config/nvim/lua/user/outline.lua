return {
  "hedyhli/outline.nvim",
  init = function()
    vim.keymap.set("n", "yo", "<cmd>OutlineOpen<cr>")
  end,
  cmd = "OutlineOpen",
  opts = {
    outline_window = {
      position = "right",
      auto_close = true,
    },
  },
}
