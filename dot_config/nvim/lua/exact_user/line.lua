return {
  {
    "heirline.nvim",
    url = "https://gitee.com/sunn4mirror/heirline.nvim.git",
    config = function(_, opts)
      local conditions = require("heirline.conditions")
      local Align = { provider = "%=%<" }
      local make_list = function(
        get_list, item_comp, left_comp, right_comp, limit
      )
        return {
          init = function(self)
            for i = 1, #self do
              self[i] = nil
            end
            local list, current = get_list()
            if #list == 0 then return end
            local left = current or 1
            local right = current or 1
            table.insert(self, self:new(item_comp))
            self[1].item = list[current or 1]
            self[1].is_active = current and true or false
            for _ = 1, limit do
              if left == 1 then
                if right == #list then
                  break
                else
                  right = right + 1
                  table.insert(self, self:new(item_comp))
                  self[#self].item = list[right]
                end
              else
                left = left - 1
                table.insert(self, 1, self:new(item_comp))
                self[1].item = list[left]
              end
              if right == #list then
                if left == 1 then
                  break
                else
                  left = left - 1
                  table.insert(self, 1, self:new(item_comp))
                  self[1].item = list[left]
                end
              else
                right = right + 1
                table.insert(self, self:new(item_comp))
                self[#self].item = list[right]
              end
            end
            if left > 1 then
              table.insert(self, 1, self:new(left_comp))
              local items = {}
              for i = 1, left - 1 do
                table.insert(items, list[i])
              end
              self[1].items = items
            end
            if right < #list then
              table.insert(self, self:new(right_comp))
              local items = {}
              for i = right + 1, #list do
                table.insert(items, list[i])
              end
              self[#self].items = items
            end
          end,
        }
      end

      local tabline = {}
      table.insert(tabline, {
        provider = function()
          local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
          if #cwd / vim.o.columns > 0.3 then
            cwd = vim.fn.pathshorten(cwd)
          end
          return " " .. cwd .. " "
        end,
      })
      table.insert(tabline, {
        make_list(
          function()
            local list = {}
            for _, i in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_get_option(i, "buflisted") then
                table.insert(list, i)
              end
            end
            local current = nil
            for j, i in ipairs(list) do
              if i == tonumber(vim.g.actual_curbuf) then
                current = j
                break
              end
            end
            return list, current
          end,
          {
            provider = function(self)
              local bufstr = (" %d"):format(self.item)
              if vim.bo[self.item].modified then
                bufstr = bufstr .. "+"
              end
              return bufstr
            end,
            hl = function(self)
              if self.is_active then
                return "TabLineSel"
              else
                return "TabLine"
              end
            end,
          },
          {
            provider = function(self)
              local trunc = " <"
              for _, i in ipairs(self.items) do
                if vim.bo[i].modified then
                  trunc = trunc .. "+"
                  break
                end
              end
              return trunc
            end,
            hl = "TabLine",
          },
          {
            provider = function(self)
              local trunc = " >"
              for _, i in ipairs(self.items) do
                if vim.bo[i].modified then
                  trunc = trunc .. "+"
                  break
                end
              end
              return trunc
            end,
            hl = "TabLine",
          },
          3
        ),
        { provider = " " },
      })
      table.insert(tabline, Align)
      for _, ele in pairs(opts.tabline or {}) do
        if type(ele) == "function" then
          ele = ele()
        end
        if type(ele.condition) == "string" then
          ele.condition = conditions[ele.condition]
        end
        table.insert(tabline, ele)
      end
      table.insert(tabline, {
        make_list(
          function()
            local list = {}
            local current = nil
            for i, t in ipairs(vim.api.nvim_list_tabpages()) do
              table.insert(list, vim.api.nvim_tabpage_get_number(t))
              if t == vim.api.nvim_get_current_tabpage() then
                current = i
              end
            end
            return list, current
          end,
          {
            provider = function(self)
              return (" %d"):format(self.item)
            end,
            hl = function(self)
              if not self.is_active then
                return "TabLine"
              else
                return "TabLineSel"
              end
            end,
          },
          { provider = " <", hl = "TabLine" },
          { provider = " >", hl = "TabLine" },
          1
        ),
        { provider = " " },
      })
      opts.tabline = tabline

      local statusline = {}
      table.insert(statusline, {
        provider = function()
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
          if filename == "" then
            filename = "[No Name]"
          end
          if #filename / vim.api.nvim_win_get_width(0) > 0.5 then
            filename = vim.fn.pathshorten(filename)
          end
          if not vim.bo.modifiable or vim.bo.readonly then
            filename = filename .. " [-]"
          elseif vim.bo.modified then
            filename = filename .. " [+]"
          end
          return " " .. filename .. " "
        end,
      })
      table.insert(statusline, Align)
      for _, ele in pairs(opts.statusline or {}) do
        if type(ele) == "function" then
          ele = ele()
        end
        if type(ele.condition) == "string" then
          ele.condition = conditions[ele.condition]
        end
        table.insert(statusline, ele)
      end
      table.insert(statusline, {
        provider = " %l/%L:%c ",
      })
      opts.statusline = statusline

      require("heirline").setup(opts)
    end,
  },
  {
    "common.nvim",
    opts = {
      highlights = {
        LineHint = { fg = 12, bg = 8 },
        LineInfo = { fg = 14, bg = 8 },
        LineWarn = { fg = 11, bg = 8 },
        LineError = { fg = 9, bg = 8 },
      },
    },
  },
}
