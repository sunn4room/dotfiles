return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    winopts = {
      split = "botright 10new",
      preview = {
        hidden = "hidden",
      },
    },
  },
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<space><space>"] = { command = ":FzfLua ", desc = "find ..." },
            ["<space>b"] = { command = "<cmd>FzfLua buffers<cr>", desc = "find buffer" },
            ["<space>f"] = { command = "<cmd>FzfLua files<cr>", desc = "find file" },
            ["<space>w"] = { command = "<cmd>FzfLua live_grep<cr>", desc = "find word" },
            ["<space>h"] = { command = "<cmd>FzfLua helptags<cr>", desc = "find help" },
            ["<space>k"] = { command = "<cmd>FzfLua keymaps<cr>", desc = "find keymap" },
          },
        },
      },
    },
  },
}
