return {
  {
    "nvim-surround",
    url = "https://gitee.com/sunn4mirror/nvim-surround.git",
    keys = {
      { "<c-g>s", mode = "i" },
      { "<c-g>S", mode = "i" },
      { "ys" },
      { "yS" },
      { "ds" },
      { "cs" },
      { "cS" },
      { "s", mode = "v" },
      { "S", mode = "v" },
    },
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "s",
        visual_line = "S",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
  },
}
