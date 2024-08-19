return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        toml = true,
        rust = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("rust-analyzer") == 1 then
        opts.servers.rust_analyzer = {
          on_attach = function(client, bufnr)
            vim.b[bufnr].formatting_client = client.name
          end,
        }
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = function(_, opts)
      table.insert(opts.adapters, require("neotest-rust"))
    end,
  },
}
