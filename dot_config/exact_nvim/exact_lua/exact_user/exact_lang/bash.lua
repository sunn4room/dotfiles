return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        bash = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("bash-language-server") == 1 then
        opts.servers.bashls = {}
      end
      if vim.fn.executable("shfmt") == 1 then
        table.insert(
          opts.null_ls.sources,
          require("null-ls").builtins.formatting.shfmt
        )
      end
    end,
  },
}
