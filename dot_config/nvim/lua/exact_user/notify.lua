return {
  {
    "just-notify.nvim",
    url = "https://gitee.com/sunn4room/just-notify.nvim.git",
    opts = {},
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        n = {
          yn = "<cmd>lua require('just-notify').show()<cr>",
        },
      },
      highlights = {
        InfoMsg = { fg = 6 },
        DebugMsg = { fg = 4 },
        TraceMsg = { fg = 7 },
      },
    },
  },
  {
    "heirline.nvim",
    opts = {
      tabline = {
        notification = {
          update = {
            "User",
            pattern = "Notification",
            callback = function()
              vim.schedule(vim.cmd.redrawtabline)
            end,
          },
          init = function(self)
            self.notifications = require("just-notify").notifications
            self.count = require("just-notify").count
            self.last = nil
            if #self.notifications ~= 0 then
              self.last = self.notifications[#self.notifications]
            end
          end,
          {
            provider = function(self)
              if self.last ~= nil then
                local msg = self.last.msg
                if vim.fn.strcharlen(msg) > 30 then
                  msg = vim.fn.strcharpart(msg, 0, 27) .. "..."
                end
                return " " .. string.gsub(msg, "%%", "%%%%") .. " "
              else
                return ""
              end
            end,
            hl = function(self)
              if self.last == nil then
                return "TabLineFill"
              elseif self.last.level == 4 then
                return "LineError"
              elseif self.last.level == 3 then
                return "LineWarn"
              elseif self.last.level == 2 then
                return "LineInfo"
              elseif self.last.level == 1 then
                return "LineHint"
              else
                return "TabLineFill"
              end
            end,
          },
          {
            provider = function(self)
              if self.count[1] ~= 0 then
                return " T" .. tostring(self.count[1])
              else
                return ""
              end
            end,
          },
          {
            provider = function(self)
              if self.count[2] ~= 0 then
                return " D" .. tostring(self.count[2])
              else
                return ""
              end
            end,
            hl = "LineHint",
          },
          {
            provider = function(self)
              if self.count[3] ~= 0 then
                return " I" .. tostring(self.count[3])
              else
                return ""
              end
            end,
            hl = "LineInfo",
          },
          {
            provider = function(self)
              if self.count[4] ~= 0 then
                return " W" .. tostring(self.count[4])
              else
                return ""
              end
            end,
            hl = "LineWarn",
          },
          {
            provider = function(self)
              if self.count[5] ~= 0 then
                return " E" .. tostring(self.count[5])
              else
                return ""
              end
            end,
            hl = "LineError",
          },
          {
            provider = function(self)
              if self.last == nil then
                return ""
              else
                return " "
              end
            end,
          },
        },
      },
    },
  },
}
