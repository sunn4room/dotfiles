return {
  {
    "hop.nvim",
    url = "https://gitee.com/sunn4mirror/hop.nvim.git",
    cmd = "HopChar1",
    opts = {
      move_cursor = false,
    },
  },
  {
    "nvim-window-picker",
    url = "https://gitee.com/sunn4mirror/nvim-window-picker.git",
    version = "2.*",
    lazy = true,
    main = "window-picker",
    opts = {
      hint = "statusline-winbar",
      highlights = {
        statusline = {
          focused = { link = "StatusLine" },
          unfocused = { link = "StatusLineNC" },
        },
      },
    },
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        nxo = {
          t = "<cmd>HopChar1<cr>",
        },
        n = {
          gw = function()
            local wid = require("window-picker").pick_window()
            if wid then
              vim.api.nvim_set_current_win(wid)
            end
          end,
        },
      },
      highlights = {
        HopNextKey = { fg = 6, bold = true },
        HopNextKey1 = { fg = 5, bold = true },
        HopNextKey2 = { fg = 4, bold = true },
        HopUnmatched = { fg = 8 },
      },
    },
  },
}
