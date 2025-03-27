vim.api.nvim_set_hl(0, "Pmenu", { ctermbg = 0, ctermfg = 7 })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = 8, ctermfg = 15 })
vim.api.nvim_set_hl(0, "PmenuKind", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "PmenuKindSel", { link = "PmenuSel" })
vim.api.nvim_set_hl(0, "PmenuExtra", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "PmenuExtraSel", { link = "PmenuSel" })
vim.api.nvim_set_hl(0, "PmenuSbar", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "PmenuThumb", { ctermbg = 7 })

return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts_extend = { "sources.default" },
  opts = {
    fuzzy = { implementation = "lua" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
    keymap = {
      preset = "default",
      ["<C-space>"] = { "show" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
  },
}
