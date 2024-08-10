return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        nix = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      table.insert(
        opts.null_ls.sources,
        require("null-ls").builtins.formatting.alejandra.with {
          condition = function(utils)
            return vim.fn.executable("alejandra") == 1
          end,
        }
      )
    end,
  },
}
