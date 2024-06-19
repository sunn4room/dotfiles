return {
  {
    "guess-indent.nvim",
    url = "https://gitee.com/sunn4mirror/guess-indent.nvim.git",
    lazy = false,
    keys = {
      { "y<tab>", "<cmd>GuessIndent<cr>", desc = "guess indent" },
    },
    opts = {},
  },
  {
    "nvim-various-textobjs",
    url = "https://gitee.com/sunn4mirror/nvim-various-textobjs.git",
    lazy = true,
    keys = {
      {
        "ii",
        "<cmd>lua require(\"various-textobjs\").indentation(\"inner\", \"inner\")<CR>",
        mode = { "o", "x" },
        desc = "inner indent",
      },
      {
        "ai",
        "<cmd>lua require(\"various-textobjs\").indentation(\"outer\", \"outer\")<CR>",
        mode = { "o", "x" },
        desc = "outer indent",
      },
    },
  },
}
