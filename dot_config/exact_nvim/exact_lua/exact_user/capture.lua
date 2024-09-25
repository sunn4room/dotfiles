return {
  {
    "sunn4room/common.nvim",
    opts = {
      globals = {
        record_status = false,
      },
      mappings = {
        n = {
          ["<cr>r"] = {
            desc = "record start",
            callback = function()
              vim.cmd [[redir @"]]
              vim.g.record_status = true
              vim.cmd [[doautocmd User RecordStart]]
            end
          },
          ["<bs>r"] = {
            desc = "record start",
            callback = function()
              vim.cmd [[redir END]]
              vim.g.record_status = false
              vim.cmd [[doautocmd User RecordEnd]]
            end
          },
        },
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = {
      tabline = {
        record = {
          update = {
            "User",
            pattern = { "RecordStart", "RecordEnd" },
            callback = function()
              vim.schedule(vim.cmd.redrawtabline)
            end,
          },
          provider = function()
            return vim.g.record_status and " 󰟞 " or ""
          end,
          hl = "LineSpecial",
        },
      },
    },
  },
}
