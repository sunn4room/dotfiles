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
        html = true,
        css = true,
        xml = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if
          vim.fn.executable(vim.env.HOME .. "/.npm-global/bin/tsserver") == 1
          and vim.fn.executable(vim.env.HOME .. "/.npm-global/bin/typescript-language-server") == 1
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
              path = vim.env.HOME .. "/.npm-global/lib/node_modules/typescript/lib/",
            },
          },
        }
        if vim.fn.executable(vim.env.HOME .. "/.npm-global/bin/vue-language-server") == 1 then
          opts.servers.volar = {
            init_options = {
              typescript = {
                tsdk = vim.env.HOME .. "/.npm-global/lib/node_modules/typescript/lib/",
              },
            },
          }
          table.insert(opts.servers.tsserver.filetypes, "vue")
          table.insert(opts.servers.tsserver.init_options.plugins, {
            name = "@vue/typescript-plugin",
            location = vim.env.HOME .. "/.npm-global/lib/node_modules/@vue/language-server",
            languages = { "vue" },
          })
        end
      end
      if vim.fn.executable(vim.env.HOME .. "/.npm-global/bin/prettier") == 1 then
        table.insert(
          opts.null_ls.sources,
          require("null-ls").builtins.formatting.prettier
        )
      end
    end,
  },
}
