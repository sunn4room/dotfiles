return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        json = true,
        javascript = true,
        typescript = true,
        tsx = true,
        vue = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if
          vim.fn.executable("typescript-language-server") == 1
          and vim.fn.executable("tsserver") == 1
      then
        opts.servers.tsserver = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          init_options = {
            plugins = {},
            tsserver = {
              path = vim.fn.system { "readlink", "/run/current-system/sw/bin/tsserver" }
                  :sub(1, -14) .. "lib/node_modules/typescript/lib/",
            },
          },
        }
        if vim.fn.executable("vue-language-server") == 1 then
          opts.servers.volar = {
            init_options = {
              typescript = {
                tsdk = vim.fn.system { "readlink", "/run/current-system/sw/bin/tsserver" }
                    :sub(1, -14) .. "lib/node_modules/typescript/lib/",
              },
            },
          }
          table.insert(opts.servers.tsserver.filetypes, "vue")
          table.insert(opts.servers.tsserver.init_options.plugins, {
            name = "@vue/typescript-plugin",
            location = vim.fn.system { "readlink", "/run/current-system/sw/bin/vue-language-server" }
                :sub(1, -25) .. "lib/node_modules/@vue/language-server/",
            languages = { "vue" },
          })
        end
      end
      if vim.fn.executable("node_modules/.bin/prettier") == 1 then
        table.insert(
          opts.null_ls.sources,
          require("null-ls").builtins.formatting.prettier
        )
      end
    end,
  },
}
