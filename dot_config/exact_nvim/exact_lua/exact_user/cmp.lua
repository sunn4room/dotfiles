return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      {
        "sunn4room/nvim-cmp-codegeex",
        -- dir = vim.env.HOME .. "/Projects/nvim-cmp-codegeex",
        opts = {
          range = 200,
          delay = 500,
        },
      },
      {
        "onsails/lspkind.nvim",
        opts = {
          symbol_map = {
            CodeGeeX = "",
          },
        },
      },
    },
    opts = function()
      local cmp = require("cmp")
      return {
        mapping = {
          ["<tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<s-tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "c" }),
          ["<cr>"] = cmp.mapping(function(fallback)
            if not (cmp.visible() and cmp.confirm { select = false }) then
              fallback()
            end
          end, { "i", "c" }),
          ["<esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() ~= nil then
              cmp.abort()
            else
              if vim.api.nvim_get_mode().mode == "i" then
                fallback()
              else
                vim.api.nvim_input("<c-\\><c-n>")
              end
            end
          end, { "i", "c" }),
          ["<pagedown>"] = cmp.mapping.scroll_docs(4),
          ["<pageup>"] = cmp.mapping.scroll_docs(-4),
        },
        sources = {
          { name = "codegeex" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        formatting = {
          format = require("lspkind").cmp_format {
            mode = "symbol",
            maxwidth = 40,
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
        completion = {
          autocomplete = {
            "InsertEnter",
            "TextChanged",
          },
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
            CmpItemKindCodeGeeX = "CmpItemKind",
          },
          commands = {
            Codegeex = { callback = function() vim.b.use_codegeex = not vim.b.use_codegeex end },
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
          if not vim.api.nvim_get_option_value("expandtab", { buf = 0 }) then
            indent = "\t"
          else
            indent = string.rep(
              " ",
              vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
            )
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
