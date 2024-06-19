return {
  {
    "outline.nvim",
    url = "https://gitee.com/sunn4mirror/outline.nvim.git",
    cmd = "OutlineOpen",
    opts = {
      outline_window = {
        width = 30,
        relative_width = false,
      },
    },
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        n = {
          yo = "<cmd>OutlineOpen<cr>",
          ["do"] = "<cmd>OutlineClose<cr>",
        },
      },
    },
  },
}
