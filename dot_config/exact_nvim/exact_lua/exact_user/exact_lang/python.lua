return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        python = true,
        toml = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("pyright") == 1 then
        opts.servers.pyright = {}
      end
      if vim.fn.executable("black") == 1 then
        table.insert(
          opts.null_ls.sources,
          require("null-ls").builtins.formatting.black
        )
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = {
      adapters = {
        python = {
          type = "executable",
          command = "python",
          args = { "-m", "debugpy.adapter" },
        },
      },
      configurations = {
        python = {
          {
            type = "python",
            request = "launch",
            name = "launch",
            program = function()
              return vim.api.nvim_buf_get_name(0)
            end,
          },
        },
      },
      type_to_filetypes = {
        python = {
          python = true,
        },
      },
    },
  },
}
