return {
  {
    "nvim-treesitter",
    url = "https://gitee.com/sunn4mirror/nvim-treesitter.git",
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter-textobjects",
        url = "https://gitee.com/sunn4mirror/nvim-treesitter-textobjects.git",
      },
      {
        "nvim-treesitter-playground",
        url = "https://gitee.com/sunn4mirror/nvim-treesitter-playground.git",
      },
    },
    opts = {
      ensure_installed = {
        yaml = true,
        json = true,
        toml = true,
        bash = true,
        lua = true,
        javascript = true,
        typescript = true,
        tsx = "typescript",
        vue = true,
        rust = true,
        python = true,
        go = true,
        markdown = true,
        html = true,
        css = true,
        vimdoc = true,
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
          },
        },
      },
      playground = {
        enable = true,
      },
    },
    config = function(_, opts)
      local configs = require("nvim-treesitter.parsers").get_parser_configs()
      local names = {}
      for name, value in pairs(opts.ensure_installed) do
        if value then
          local url = "https://gitee.com/sunn4mirror/tree-sitter-" .. name
          if type(value) == "string" then
            url = "https://gitee.com/sunn4mirror/tree-sitter-" .. value
          end
          configs[name].install_info.url = url
          table.insert(names, name)
        end
      end
      opts.ensure_installed = names
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "common.nvim",
    opts = {
      highlights = {
        ["@markup.heading"] = { fg = 13, bold = true },
      },
      mappings = {
        n = {
          ["c,"] = function()
            local ok, n = pcall(vim.treesitter.get_node)
            if not ok then return end
            local nc = n:child_count()
            if nc < 3 then return end
            local cursor = vim.api.nvim_win_get_cursor(0)
            local c1 = cursor[1] - 1
            local c2 = cursor[2]
            for i = 0, nc - 1 do
              local c = n:child(i)
              local s1, s2, e1, e2 = c:range()
              local m = c2
              if s2 > m then m = s2 end
              if e2 > m then m = e2 end
              m = m + 1
              local cm = c1 * m + c2
              local sm = s1 * m + s2
              local em = e1 * m + e2
              if sm <= cm and em > cm then
                if i == 0 or i == nc - 1 then return end
                local n1s1, n1s2, n1e1, n1e2 = n:child(i - 1):range()
                local n2s1, n2s2, n2e1, n2e2 = n:child(i + 1):range()
                local lines = vim.api.nvim_buf_get_text(0, n2s1, n2s2, n2e1, n2e2,
                  {})
                for ii, line in ipairs(vim.api.nvim_buf_get_text(0, n1e1, n1e2, n2s1, n2s2, {})) do
                  if ii == 1 then
                    lines[#lines] = lines[#lines] .. line
                  else
                    table.insert(lines, line)
                  end
                end
                for ii, line in ipairs(vim.api.nvim_buf_get_text(0, n1s1, n1s2, n1e1, n1e2, {})) do
                  if ii == 1 then
                    lines[#lines] = lines[#lines] .. line
                  else
                    table.insert(lines, line)
                  end
                end
                vim.api.nvim_buf_set_text(0, n1s1, n1s2, n2e1, n2e2, lines)
                break
              end
            end
          end,
        },
      },
    },
  },
}
