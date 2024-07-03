return {
  {
    "LuaSnip",
    url = "https://gitee.com/sunn4mirror/LuaSnip.git",
    version = "v2.*",
    submodules = false,
    lazy = true,
    opts = {
      snippets = {
        all = {
          ["\"\""] = {
            "\"$1\"",
          },
          ["''"] = {
            "'$1'",
          },
          ["``"] = {
            "`$1`",
          },
          ["{}"] = {
            "{$1}",
          },
          ["{-}"] = {
            "{",
            "$t$1",
            "}",
          },
          ["[]"] = {
            "[$1]",
          },
          ["[-]"] = {
            "[",
            "$t$1",
            "]",
          },
          ["()"] = {
            "($1)",
          },
          ["(-)"] = {
            "(",
            "$t$1",
            ")",
          },
          ["<>"] = {
            "<$1>",
          },
          ["<><>"] = {
            "<$1>$2<$1>",
          },
          ["<-><>"] = {
            "<$1 $2>$3<$1>",
          },
          ["<>-<>"] = {
            "<$1>",
            "$t$2",
            "<$1>",
          },
          ["<->-<>"] = {
            "<$1 $2>",
            "$t$3",
            "<$1>",
          },
          ["<-->-<>"] = {
            "<$1",
            "$t$2",
            ">",
            "$t$3",
            "<$1>",
          },
        },
        rust = {
          ["pretty_env_logger"] = {
            "if std::env::var_os(\"$1\").is_none() {",
            "$tstd::env::set_var(\"$1\", \"info\");",
            "}",
            "pretty_env_logger::init_custom_env(\"$1\");",
          },
        },
      },
    },
    config = function(_, opts)
      local ls = require("luasnip")
      local lse = require("luasnip.extras")

      local snippets = opts.snippets
      opts.snippets = nil
      ls.config.setup(opts)

      local ctx = {
        n = ls.snippet_node,
        t = ls.text_node,
        i = ls.insert_node,
        f = ls.function_node,
        r = lse.rep,
        indent = function(n)
          n = n or 1
          return ls.function_node(function()
            local indent
            if not vim.api.nvim_buf_get_option(0, "expandtab") then
              indent = "\t"
            else
              indent = string.rep(" ",
                vim.api.nvim_buf_get_option(0, "shiftwidth"))
            end
            return string.rep(indent, n)
          end)
        end,
      }

      local escape = function(t)
        local ele = {}
        local set = {}
        for _, l in ipairs(t) do
          while true do
            local index = l:find("%$")
            if index then
              table.insert(ele, ctx.t { l:sub(1, index - 1) })
              local left, right = l:find("^%d+", index + 1)
              if left then
                local num = tonumber(l:sub(left, right))
                if num > 0 and set[num] then
                  table.insert(ele, ctx.r(num))
                else
                  table.insert(ele, ctx.i(num))
                  if num > 0 then
                    ---@diagnostic disable-next-line: need-check-nil
                    set[num] = true
                  end
                end
                l = l:sub(right + 1)
              else
                local c = l:sub(index + 1, index + 1)
                if c == "t" then
                  table.insert(ele, ctx.indent())
                else
                  table.insert(ele, ctx.t { c })
                end
                l = l:sub(index + 2)
              end
            else
              table.insert(ele, ctx.t { l })
              break
            end
          end
          table.insert(ele, ctx.t { "", "" })
        end
        ele[#ele] = nil
        return ele
      end

      for ft, ss in pairs(snippets) do
        local sl = {}
        for trig, def in pairs(ss) do
          if type(def) == "function" then
            table.insert(sl, ls.snippet(trig, def(ctx)))
          elseif type(def) == "table" then
            table.insert(sl, ls.snippet(trig, escape(def)))
          end
        end
        ls.add_snippets(ft, sl)
      end
    end,
  },
  {
    "nvim-cmp",
    url = "https://gitee.com/sunn4mirror/nvim-cmp.git",
    dependencies = {
      {
        "cmp-buffer",
        url = "https://gitee.com/sunn4mirror/cmp-buffer.git",
      },
      {
        "cmp-path",
        url = "https://gitee.com/sunn4mirror/cmp-path.git",
      },
      {
        "cmp-cmdline",
        url = "https://gitee.com/sunn4mirror/cmp-cmdline.git",
      },
      {
        "cmp-nvim-lsp",
        url = "https://gitee.com/sunn4mirror/cmp-nvim-lsp.git",
      },
      "LuaSnip",
      {
        "cmp-luasnip",
        url = "https://gitee.com/sunn4mirror/cmp-luasnip.git",
      },
      {
        "codegeex.nvim",
        lazy = true,
        url = "https://gitee.com/sunn4room/codegeex.nvim.git",
        -- dir = "~/Projects/codegeex.nvim",
        opts = {},
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local codegeex = require("codegeex")
      cmp.setup {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone",
          autocomplete = false,
          -- autocomplete = {
          --   cmp.TriggerEvent.TextChanged,
          -- },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = "single",
          },
          documentation = {
            border = "single",
          },
        },
        formatting = {
          fields = { "abbr", "kind" },
          format = function(_, item)
            local kind2icon = {
              Text = "S",
              Method = "F",
              Function = "F",
              Constructor = "=",
              Field = "+",
              Variable = "+",
              Class = "C",
              Interface = "I",
              Module = "M",
              Property = "P",
              Unit = "U",
              Value = "V",
              Enum = "E",
              Keyword = "K",
              Snippet = "$",
              Color = "#",
              File = "\\",
              Reference = "R",
              Folder = "/",
              EnumMember = ">",
              Constant = "-",
              Struct = "&",
              Event = "@",
              Operator = "*",
              TypeParameter = "T",
            }
            item.kind = kind2icon[item.kind] or "?"
            local max_length = 50
            if vim.fn.strcharlen(item.abbr) > max_length then
              item.abbr = vim.fn.strcharpart(item.abbr, 0, max_length - 1) .. "…"
            end
            item.menu = nil
            return item
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
        mapping = {
          ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item {
                behavior = cmp.SelectBehavior.Select,
              }
            elseif codegeex.visible() then
              return
            else
              if vim.api.nvim_get_mode().mode == "i" then
                local cursor = vim.api.nvim_win_get_cursor(0)
                local prefix = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]:sub(1, col)
                if vim.fn.trim(prefix) == "" then
                  fallback()
                else
                  cmp.complete()
                end
              else
                cmp.complete()
              end
            end
          end, { "i", "c" }),
          ["<s-tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item {
                behavior = cmp.SelectBehavior.Select,
              }
            elseif codegeex.visible() then
              return
            else
              if vim.api.nvim_get_mode().mode == "i" then
                codegeex.complete()
              end
            end
          end, { "i", "c" }),
          ["<c-n>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i" }),
          ["<c-p>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i" }),
          ["<cr>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm { select = true }
            elseif codegeex.visible() then
              codegeex.confirm()
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.close()
            elseif codegeex.visible() then
              codegeex.cancel()
            else
              local mode = vim.api.nvim_get_mode()
              mode = mode.mode
              if mode == "i" then
                fallback()
              else
                vim.api.nvim_input("<c-\\><c-n>")
              end
            end
          end, { "i", "c" }),
        },
      }
      cmp.setup.cmdline(":", {
        sources = {
          { name = "cmdline" },
          { name = "path" },
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
}
