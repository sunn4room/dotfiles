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
    opts = {
      null_ls = {
        sources = {
          formatting = {
            alejandra = {
              condition = function()
                return vim.fn.executable("alejandra") == 1
              end,
            },
          },
        },
      },
    },
  },
}
