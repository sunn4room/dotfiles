return {
  "smoka7/hop.nvim",
  init = function()
    vim.api.nvim_set_hl(0, "HopNextKey", { ctermfg = 6, bold = true })
    vim.api.nvim_set_hl(0, "HopNextKey1", { ctermfg = 5, bold = true })
    vim.api.nvim_set_hl(0, "HopNextKey2", { ctermfg = 4, bold = true })
    vim.api.nvim_set_hl(0, "HopUnmatched", { ctermfg = 8 })
  end,
  keys = {
    { "s", "<cmd>HopChar1<cr>", mode = { "n", "v" } },
  },
  opts = {},
}
