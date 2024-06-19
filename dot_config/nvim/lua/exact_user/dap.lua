return {
  {
    "nvim-dap",
    url = "https://gitee.com/sunn4mirror/nvim-dap.git",
    lazy = true,
    config = function()
      local dap = require("dap")
      dap.adapters = {
        python = {
          type = "executable",
          command = "python",
          args = { "-m", "debugpy.adapter" },
        },
        lldb = {
          type = "executable",
          command = "lldb-vscode",
          name = "lldb",
        },
      }
      dap.configurations = {
        python = {
          {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
          },
        },
        rust = {
          {
            type = "lldb",
            request = "launch",
            name = "Launch file",
            program = function()
              vim.fn.system("cargo build")
              local metadata_json = vim.fn.system(
                "cargo metadata --format-version 1 --no-deps")
              local metadata = vim.fn.json_decode(metadata_json)
              local target_name = metadata.packages[1].targets[1].name
              local target_dir = metadata.target_directory
              return target_dir .. "/debug/" .. target_name
            end,
          },
        },
      }
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dap.repl.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap.repl.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap.repl.close()
      end
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "",
        linehl = "DapBreakpoint",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "",
        linehl = "DapBreakpointCondition",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "",
        linehl = "DapStopped",
        numhl = "",
      })
    end,
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        n = {
          cm = function()
            require("dap").toggle_breakpoint()
          end,
          cM = function()
            require("dap").set_breakpoint(vim.fn.input(
              "Breakpoint condition: "))
          end,
          ym = function()
            require("dap").continue()
          end,
          dm = function()
            require("dap").terminate()
          end,
          gm = function()
            require("dap").step_over()
          end,
          ["g."] = function()
            require("dap").step_into()
          end,
          ["g,"] = function()
            require("dap").step_out()
          end,
        },
      },
      highlights = {
        DapBreakpoint = { bg = 8 },
        DapBreakpointCondition = { bg = 8 },
        DapStopped = { fg = 0, bg = 6, bold = true },
      },
    },
  },
}
