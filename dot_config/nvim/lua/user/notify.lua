vim.notify = function(m, l, o)
  if type(l) == "string" then
    l = ({trace=0, debug=1, info=2, warn=3, warning=3, error=4})[l]
  end
  o = o or {}
  if o.timeout == nil then
    o.timeout = ({2000, 3000, 5000, 10000, false})[(l or 2)+1]
  end
  return require("notify")(m, l, o)
end

vim.keymap.set("n", "yn", "<cmd>Notifications<cr>")
vim.keymap.set("n", "dn", function() require("notify").dismiss() end)

vim.api.nvim_set_hl(0, "NotifyERRORBorder", { ctermfg = 1, ctermbg = 0 })
vim.api.nvim_set_hl(0, "NotifyWARNBorder", { ctermfg = 3, ctermbg = 0 })
vim.api.nvim_set_hl(0, "NotifyINFOBorder", { ctermfg = 2, ctermbg = 0 })
vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { ctermfg = 6, ctermbg = 0 })
vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { ctermfg = 4, ctermbg = 0 })
vim.api.nvim_set_hl(0, "NotifyERRORIcon", { link = "NotifyERRORBorder" })
vim.api.nvim_set_hl(0, "NotifyWARNIcon", { link = "NotifyWARNBorder" })
vim.api.nvim_set_hl(0, "NotifyINFOIcon", { link = "NotifyINFOBorder" })
vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { link = "NotifyDEBUGBorder" })
vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { link = "NotifyTRACEBorder" })
-- vim.api.nvim_set_hl(0, "NotifyERRORTitle", { link = "NotifyERRORBorder" })
-- vim.api.nvim_set_hl(0, "NotifyWARNTitle", { link = "NotifyWARNBorder" })
-- vim.api.nvim_set_hl(0, "NotifyINFOTitle", { link = "NotifyINFOBorder" })
-- vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { link = "NotifyDEBUGBorder" })
-- vim.api.nvim_set_hl(0, "NotifyTRACETitle", { link = "NotifyTRACEBorder" })

return {
  "rcarriga/nvim-notify",
  lazy = true,
  opts = {
    icons = {
      TRACE = "󰛿",
      DEBUG = "󰏥",
      INFO = "󰋼",
      WARN = "󰀨",
      ERROR = "󰅙",
    },
    level = 0,
    minimum_width = 40,
    max_width = 40,
    max_height = 5,
    top_down = false,
  },
}
