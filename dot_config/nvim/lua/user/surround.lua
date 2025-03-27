return {
  "kylechui/nvim-surround",
  keys = {
    { "ys", mode = "n" },
    { "yS", mode = "n" },
    { "ds", mode = "n" },
    { "cs", mode = "n" },
    { "cS", mode = "n" },
    { "gs", mode = "v" },
    { "gS", mode = "v" },
    { "<c-g>s", mode = "i" },
    { "<c-g>S", mode = "i" },
  },
  opts = {
    keymaps = {
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      delete = "ds",
      change = "cs",
      change_line = "cS",
      visual = "gs",
      visual_line = "gS",
      insert = "<c-g>s",
      insert_line = "<c-g>S",
    },
  },
}
