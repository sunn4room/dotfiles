return {
  "mfussenegger/nvim-dap",
  lazy = true,
  opts = {
    adapters = {},
    configurations = {},
  },
  config = function(_, opts)
    local dap = require("dap")
    dap.adapters = opts.adapters
    dap.configurations = opts.configurations
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
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["\\m"] = { callback = function()
              require("dap").toggle_breakpoint()
            end, desc = "toggle breakpoint" },
            ["\\M"] = { callback = function()
              require("dap").set_breakpoint(
                vim.fn.input("Breakpoint condition: ")
              )
            end, desc = "set condition breakpoint" },
            ["<cr>m"] = { callback = function()
              require("dap").continue()
            end, desc = "start debug" },
            ["<bs>m"] = { callback = function()
              require("dap").terminate()
            end, desc = "stop debug" },
            ["gm"] = { callback = function()
              require("dap").step_over()
            end, desc = "step over" },
            ["g."] = { callback = function()
              require("dap").step_into()
            end, desc = "step into" },
            ["g,"] = { callback = function()
              require("dap").step_out()
            end, desc = "step out" },
          },
        },
        highlights = {
          DapBreakpoint = { bg = 8 },
          DapBreakpointCondition = { bg = 8 },
          DapStopped = { fg = 0, bg = 6, bold = true },
        },
      },
    },
  },
}
