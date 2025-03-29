return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "javascript", "typescript", "tsx", "jsdoc", "vue" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
          },
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location =
                    "/usr/lib/node_modules/@vue/language-server",
                    languages = { "vue" },
                  },
                },
              },
            },
          },
        },
        volar = {
          init_options = {
            vue = {
              hybridMode = true,
            },
            typescript = {
              tsdk =
              "/usr/lib/node_modules/@vtsls/language-server/node_modules/typescript/lib",
            },
          },
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      table.insert(opts.sources, null_ls.builtins.formatting.prettier.with {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        -- condition = function(utils)
        --   return utils.root_has_file {
        --     ".prettierrc",
        --     ".prettierrc.json",
        --     ".prettierrc.json5",
        --     ".prettierrc.yml",
        --     ".prettierrc.yaml",
        --     ".prettierrc.toml",
        --     ".prettierrc.js",
        --     "prettierrc.config.js",
        --     ".prettierrc.ts",
        --     "prettierrc.config.ts",
        --     ".prettierrc.mjs",
        --     "prettierrc.config.mjs",
        --     ".prettierrc.mts",
        --     "prettierrc.config.mts",
        --     ".prettierrc.cjs",
        --     "prettierrc.config.cjs",
        --     ".prettierrc.cts",
        --     "prettierrc.config.cts",
        --   }
        -- end,
      })
    end,
  },
}
