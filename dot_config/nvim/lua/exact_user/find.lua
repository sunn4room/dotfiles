return {
  {
    "fzf-lua",
    url = "https://gitee.com/sunn4mirror/fzf-lua.git",
    init = function()
      vim.ui.select_origin = vim.ui.select
      vim.ui.select = function(items, opts, on_choice)
        local ok, fzf_lua = pcall(require, "fzf-lua")
        if ok then
          fzf_lua.register_ui_select()
        else
          vim.ui.select = vim.ui.select_origin
        end
        return vim.ui.select(items, opts, on_choice)
      end
    end,
    cmd = "FzfLua",
    opts = {
      winopts = {
        split = "topleft new",
        preview = {
          hidden = "hidden",
        },
      },
    },
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        n = {
          ["<space>w"] = "<cmd>FzfLua live_grep<cr>",
          ["<space>f"] = "<cmd>FzfLua files<cr>",
          ["<space>b"] = "<cmd>FzfLua buffers<cr>",
          ["<space>h"] = "<cmd>FzfLua help_tags<cr>",
          ["<space>k"] = "<cmd>FzfLua keymaps<cr>",
        },
      },
      highlights = {
        FzfLuaBorder = "FloatBorder",
      },
    },
  },
}
