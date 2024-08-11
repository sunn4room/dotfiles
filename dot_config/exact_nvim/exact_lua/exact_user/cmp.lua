return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      {
        "luozhiya/fittencode.nvim",
        cmd = "Fitten",
        opts = {
          completion_mode = "source",
          chat = {
            sidebar = {
              width = 35,
              position = "right",
            },
          },
        },
      },
      {
        "onsails/lspkind.nvim",
        opts = {
          symbol_map = {
            FittenCode = "",
          },
        },
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function()
      local cmp = require("cmp")
      return {
        mapping = {
          ["<c-l>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = false }
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<c-h>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.abort()
            end
          end, { "i", "c" }),
          ["<c-j>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
            end
          end, { "i", "c" }),
          ["<c-k>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
            end
          end, { "i", "c" }),
          ["<c-d>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.scroll_docs(4)
            end
          end, { "i", "c" }),
          ["<c-u>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.scroll_docs(-4)
            end
          end, { "i", "c" }),
        },
        completion = {
          completeopt = "menu,menuone,preview",
        },
        sources = {
          { name = "fittencode" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        formatting = {
          format = require("lspkind").cmp_format {
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
          },
        },
        window = {
          completion = {
            border = "rounded",
          },
          documentation = {
            border = "rounded",
          },
        },
        performance = {
          debounce = 300,
        },
        cmdline = {
          search = {
            sources = {
              { name = "buffer" },
            },
          },
          command = {
            sources = {
              { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
              { name = "path" },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline({ "/", "?" }, opts.cmdline.search)
      cmp.setup.cmdline(":", opts.cmdline.command)
    end,
    specs = {
      {
        "sunn4room/common.nvim",
        opts = {
          highlights = {
            CmpItemAbbr = { fg = 7 },
            CmpItemAbbrMatch = { fg = 5 },
            CmpItemAbbrMatchFuzzy = "CmpItemAbbrMatch",
            CmpItemKind = { fg = 4 },
            CmpItemKindFittenCode = "CmpItemKind",
          },
          mappings = {
            n = {
              ["<cr>q"] = { command = "<cmd>Fitten start_chat<cr>", desc = "start chat" },
              ["\\q"] = { command = "<cmd>Fitten toggle_chat<cr>", desc = "toggle chat" },
            },
          },
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    main = "luasnip",
    lazy = true,
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
      snippets = {
        all = {
          sunn4room = { "sunn4room" },
        },
      },
    },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.setup(opts)
      luasnip.indent_node = function(n)
        n = n or 1
        return luasnip.function_node(function()
          local indent
          if not vim.api.nvim_buf_get_option(0, "expandtab") then
            indent = "\t"
          else
            indent = string.rep(" ",
              vim.api.nvim_buf_get_option(0, "shiftwidth"))
          end
          return string.rep(indent, n)
        end)
      end
      luasnip.extras = require("luasnip.extras")
      local escape = function(t)
        local ele = {}
        local set = {}
        for _, l in ipairs(t) do
          while true do
            local index = l:find("%$")
            if index then
              table.insert(ele, luasnip.t { l:sub(1, index - 1) })
              local left, right = l:find("^%d+", index + 1)
              if left then
                local num = tonumber(l:sub(left, right))
                if num > 0 and set[num] then
                  table.insert(ele, luasnip.r(num))
                else
                  table.insert(ele, luasnip.i(num))
                  if num > 0 then
                    ---@diagnostic disable-next-line: need-check-nil
                    set[num] = true
                  end
                end
                l = l:sub(right + 1)
              else
                local c = l:sub(index + 1, index + 1)
                if c == "t" then
                  table.insert(ele, luasnip.indent_node())
                else
                  table.insert(ele, luasnip.t { c })
                end
                l = l:sub(index + 2)
              end
            else
              table.insert(ele, luasnip.t { l })
              break
            end
          end
          table.insert(ele, luasnip.t { "", "" })
        end
        ele[#ele] = nil
        return ele
      end
      for ft, ss in pairs(opts.snippets) do
        local sl = {}
        for trig, def in pairs(ss) do
          if type(def) == "function" then
            table.insert(sl, luasnip.snippet(trig, def(luasnip)))
          elseif type(def) == "table" then
            table.insert(sl, luasnip.snippet(trig, escape(def)))
          end
        end
        luasnip.add_snippets(ft, sl)
      end
    end,
    specs = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = { { "saadparwaiz1/cmp_luasnip" } },
        opts = function(_, opts)
          local luasnip, cmp = require "luasnip", require "cmp"

          if not opts.snippet then opts.snippet = {} end
          opts.snippet.expand = function(args) luasnip.lsp_expand(args.body) end

          if not opts.sources then opts.sources = {} end
          table.insert(opts.sources, { name = "luasnip" })

          if not opts.mappings then opts.mappings = {} end
          opts.mapping["<c-n>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i" })
          opts.mapping["<c-p>"] = cmp.mapping(function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i" })
        end,
      },
    },
  },
}
