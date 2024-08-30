return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        go = true,
        gomod = true,
        gosum = true,
        gowork = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          on_attach = function(client, bufnr)
            vim.b[bufnr].formatting_client = client.name
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = {
      adapters = {
        go = {
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        },
      },
      configurations = {
        go = {
          {
            type = "go",
            name = "Run current file",
            request = "launch",
            program = "${file}",
            args = function()
              local input = vim.fn.input("args: ", vim.b.run_args or "")
              vim.b.run_args = input
              return vim.fn.split(input, " ")
            end,
          },
          {
            type = "go",
            name = "Test current file",
            request = "launch",
            program = "${file}",
            mode = "test",
            args = function()
              local input = vim.fn.input("args: ", vim.b.test_args or "")
              vim.b.test_args = input
              return vim.fn.split(input, " ")
            end,
          },
        },
      },
      type_to_filetypes = {
        go = {
          go = true,
        },
      },
    },
  },
}
