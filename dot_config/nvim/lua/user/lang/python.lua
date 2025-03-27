return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      table.insert(opts.sources, null_ls.builtins.formatting.isort)
      table.insert(opts.sources, null_ls.builtins.formatting.black)
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    event = "User NvimDapLoaded",
    config = function()
      require("dap-python").setup("python3")
    end,
  },
}
