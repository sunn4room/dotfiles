return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        lua = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("lua-language-server") == 1 then
        opts.servers.lua_ls = {
          on_attach = function(client, bufnr)
            vim.b[bufnr].formatting_client = client.name
            local cwdname = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            if
                cwdname == "nvim"
                or cwdname:sub(1, 5) == "nvim-"
                or cwdname:sub(-5, -1) == ".nvim"
            then
              require("lazy").load {
                plugins = { "lazydev.nvim" },
              }
            end
          end,
        }
      end
    end,
  },
  {
    "folke/lazydev.nvim",
    lazy = true,
    dependencies = {
      { "Bilal2453/luvit-meta" },
    },
    opts = {
      library = {
        "luvit-meta/library",
      },
    },
  },
}
