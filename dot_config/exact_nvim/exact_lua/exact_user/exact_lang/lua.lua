return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("lua-language-server") == 1 then
        opts.servers.lua_ls = {
          on_attach = function(client, bufnr)
            vim.b[bufnr].formatting_client = client.name
          end,
        }
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        lua = true,
      },
    },
  },
}
