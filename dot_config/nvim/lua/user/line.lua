vim.opt.showtabline = 2

vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = 8, ctermfg = 15 })
vim.api.nvim_set_hl(0, "StatusLineNC", { ctermbg = 8, ctermfg = 12 })
vim.api.nvim_set_hl(0, "StatusLineHint", { ctermfg = 12, ctermbg = 8 })
vim.api.nvim_set_hl(0, "StatusLineInfo", { ctermfg = 14, ctermbg = 8 })
vim.api.nvim_set_hl(0, "StatusLineWarn", { ctermfg = 11, ctermbg = 8 })
vim.api.nvim_set_hl(0, "StatusLineError", { ctermfg = 9, ctermbg = 8 })
vim.api.nvim_set_hl(0, "StatusLineSpecial", { ctermfg = 13, ctermbg = 8 })
vim.api.nvim_set_hl(0, "StatusLineOk", { ctermfg = 10, ctermbg = 8 })
vim.api.nvim_set_hl(0, "TabLineSel", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "TabLine", { link = "StatusLineNC" })
vim.api.nvim_set_hl(0, "TabLineFill", { link = "TabLineSel" })
vim.api.nvim_set_hl(0, "WinSeparator", { link = "StatusLine" })

return {
  "rebelot/heirline.nvim",
  opts = {
    tabline = {
      {
        provider = function()
          return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. " "
        end,
      },
      { provider = "%=" },
      {
        provider = function()
          local total = 0
          local current = 0
          for _, i in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_get_option_value("buflisted", { buf = i }) then
              total = total + 1
              if vim.api.nvim_get_current_buf() == i then
                current = total
              end
            end
          end
          return " " .. current .. "/" .. total .. " "
        end,
      },
      {
        provider = function()
          return " " ..
          vim.api.nvim_get_current_tabpage() .. "/" .. #vim.api.nvim_list_tabpages() .. " "
        end,
      },
    },
    statusline = {
      {
        provider = function()
          if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "nofile" then
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            if filetype == "" then
              filetype = "NO TYPE"
            end
            return " [" .. filetype .. "] "
          end
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
          if filename == "" then
            filename = "[NO NAME]"
          end
          return " " .. filename .. " "
        end,
      },
      {
        condition = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) == ""
              and (
                vim.api.nvim_get_option_value("modified", { buf = 0 })
                or (not vim.api.nvim_get_option_value("modifiable", { buf = 0 }))
              )
        end,
        provider = function()
          if vim.api.nvim_get_option_value("modified", { buf = 0 }) then
            return " 󰆓 "
          else
            return " 󰌾 "
          end
        end,
        hl = function()
          if vim.api.nvim_get_option_value("modified", { buf = 0 }) then
            return "StatusLineWarn"
          else
            return "StatusLineError"
          end
        end,
      },
      { provider = "%=" },
      {
        update = {
          "DiagnosticChanged",
          "BufEnter",
          callback = vim.schedule_wrap(function()
            vim.cmd([[redrawstatus]])
          end),
        },
        {
          condition = function(self)
            if not require("heirline.conditions").is_active() then
              return false
            end
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            return self.errors + self.warnings + self.infos + self.hints ~= 0
          end,
          { provider = " " },
          {
            condition = function(self)
              return self.hints ~= 0
            end,
            provider = function(self)
              return string.format("󰠠 %d ", self.hints)
            end,
            hl = "StatusLineHint",
          },
          {
            condition = function(self)
              return self.infos ~= 0
            end,
            provider = function(self)
              return string.format("󰋼 %d ", self.infos)
            end,
            hl = "StatusLineInfo",
          },
          {
            condition = function(self)
              return self.warnings ~= 0
            end,
            provider = function(self)
              return string.format(" %d ", self.warnings)
            end,
            hl = "StatusLineWarn",
          },
          {
            condition = function(self)
              return self.errors ~= 0
            end,
            provider = function(self)
              return string.format(" %d ", self.errors)
            end,
            hl = "StatusLineError",
          },
        },
      },
      {
        provider = " %l/%L  %c ",
      },
    },
  },
}
