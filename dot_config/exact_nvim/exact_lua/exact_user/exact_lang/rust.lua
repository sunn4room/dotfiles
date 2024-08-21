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
    "mfussenegger/nvim-dap",
    opts = {
      configurations = {
        rust = { {
          type = "lldb",
          request = "launch",
          name = "launch",
          program = function()
            local lines = vim.fn.systemlist { "cargo", "build", "--quiet", "--message-format", "json" }
            if vim.v.shell_error ~= 0 then
              vim.notify("cargo build failed", vim.log.levels.ERROR)
              return require("dap").ABORT
            end
            local executables = {}
            for _, line in ipairs(lines) do
              local json = vim.fn.json_decode(line)
              if
                  type(json) == "table"
                  and json.reason == "compiler-artifact"
                  and json.executable ~= nil
                  and vim.tbl_contains(json.target.kind, "bin")
              then
                table.insert(executables, json.executable)
              end
            end
            if #executables == 0 then
              vim.notify("main module not found", vim.log.levels.ERROR)
              return require("dap").ABORT
            elseif #executables == 1 then
              return executables[1]
            else
              local prompt = "items:\n"
              for i, e in ipairs(executables) do
                prompt = prompt .. "  " .. tostring(i) .. ". " .. e .. "\n"
              end
              prompt = prompt .. "select: "
              local select = tonumber(vim.fn.input(prompt))
              if select then
                return executables[select] or require("dap").ABORT
              else
                return require("dap").ABORT
              end
            end
          end,
        } },
      },
    },
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
