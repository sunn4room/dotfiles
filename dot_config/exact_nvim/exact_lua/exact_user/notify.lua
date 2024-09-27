local n2s = {
  [0] = "TRACE",
  [1] = "DEBUG",
  [2] = "INFO",
  [3] = "WARN",
  [4] = "ERROR",
}
local n2h = {
  [0] = "TraceMsg",
  [1] = "DebugMsg",
  [2] = "InfoMsg",
  [3] = "WarnMsg",
  [4] = "ErrorMsg",
}

local notif_idx = 0
local notif_level_idx = 0
local notif_level = -1

return {
  "sunn4room/notify.nvim",
  -- dir = vim.env.HOME .. "/Projects/notify.nvim",
  config = function()
    vim.notify = require("notify")
  end,
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>n"] = {
              desc = "notifications",
              callback = function()
                if notif_idx ~= notif_level_idx then
                  local notifs = require("notify").notifications
                  local output = {}
                  for i = notif_idx + 1, notif_level_idx do
                    local r = notifs[i]
                    table.insert(output, { r.time, "MoreMsg" })
                    table.insert(output, { " ", "MsgArea" })
                    table.insert(output, { n2s[r.level] .. "\n", n2h[r.level] })
                    table.insert(output, { r.message .. "\n", "MsgArea" })
                  end
                  notif_idx = notif_level_idx
                  notif_level = -1
                  vim.cmd [[doautocmd User Notified]]
                  vim.api.nvim_echo(output, true, {})
                end
              end,
            },
            ["<cr>N"] = {
              desc = "notifications history",
              callback = function()
                if notif_idx ~= 0 then
                  local notifs = require("notify").notifications
                  local output = {}
                  for i = 1, notif_idx do
                    local r = notifs[i]
                    table.insert(output, { r.time, "MoreMsg" })
                    table.insert(output, { " ", "MsgArea" })
                    table.insert(output, { n2s[r.level] .. "\n", n2h[r.level] })
                    table.insert(output, { r.message .. "\n", "MsgArea" })
                  end
                  vim.api.nvim_echo(output, true, {})
                end
              end,
            },
          },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      opts = {
        notify = {
          update = {
            "User",
            pattern = "Notified",
            callback = function()
              vim.schedule(vim.cmd.redrawtabline)
            end,
          },
          {
            condition = function()
              return #require("notify").notifications ~= notif_idx
            end,
            {
              provider = " ",
              hl = function()
                local notifs = require("notify").notifications
                if #notifs ~= notif_level_idx then
                  for i = notif_level_idx + 1, #notifs do
                    if notifs[i].level > notif_level then
                      notif_level = notifs[i].level
                    end
                  end
                  notif_level_idx = #notifs
                end
                if notif_level == 0 then
                  return "LineTrace"
                elseif notif_level == 1 then
                  return "LineDebug"
                elseif notif_level == 2 then
                  return "LineInfo"
                elseif notif_level == 3 then
                  return "LineWarn"
                elseif notif_level == 4 then
                  return "LineError"
                end
              end,
            },
            {
              provider = function()
                local notifs = require("notify").notifications
                local msg = string.gsub(notifs[#notifs].message, "%%", "%%%%")
                if #msg > 30 then
                  msg = msg:sub(1, 29) .. "…"
                end
                return msg
              end,
              hl = function()
                local notifs = require("notify").notifications
                local level = notifs[#notifs].level
                if level == 0 then
                  return "LineTrace"
                elseif level == 1 then
                  return "LineDebug"
                elseif level == 2 then
                  return "LineInfo"
                elseif level == 3 then
                  return "LineWarn"
                elseif level == 4 then
                  return "LineError"
                end
              end,
            },
            { provider = " " },
          },
          {
            condition = function()
              return not vim.tbl_isempty(require("notify").progresses)
            end,
            { provider = " ", hl = "LineSpecial" },
            {
              provider = function()
                local items = {}
                for name, tokens in pairs(require("notify").progresses) do
                  local count = 0
                  local total = 0
                  for _, percentage in pairs(tokens) do
                    count = count + 1
                    total = total + percentage
                  end
                  items[#items + 1] = name ..
                      ":" .. tostring(math.floor(total / count))
                end
                return vim.fn.join(items, ",")
              end,
            },
            { provider = " " },
          },
        },
      },
    },
  },
}
