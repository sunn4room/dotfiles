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
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --   dap.repl.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --   dap.repl.close()
    -- end
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
            ["\\d"] = {
              callback = function()
                require("dap").toggle_breakpoint()
              end,
              desc = "toggle breakpoint",
            },
            ["\\D"] = {
              callback = function()
                require("dap").set_breakpoint(
                  vim.fn.input("Breakpoint condition: ")
                )
              end,
              desc = "set condition breakpoint",
            },
            ["<cr>m"] = {
              callback = function()
                local dap = require("dap")
                local bufnr = vim.api.nvim_get_current_buf()
                local filetype = vim.bo[bufnr].filetype
                local configs = dap.configurations[filetype]
                if configs then
                  local program = configs[1].program()
                  if program ~= dap.ABORT then
                    program = { program }
                    if configs[1].args then
                      local args = configs[1].args()
                      if args then
                        for _, arg in ipairs(args) do
                          table.insert(program, arg)
                        end
                      end
                    end
                    vim.cmd("belowright sp term://" ..
                    vim.fn.join(vim.tbl_map(function(p)
                      return "\\\"" .. p .. "\\\""
                    end, program), " "))
                  end
                end
              end,
              desc = "start main",
            },
            ["<cr>M"] = {
              callback = function()
                require("dap").continue()
              end,
              desc = "start main in debug mode",
            },
            ["<bs>d"] = {
              callback = function()
                require("dap").terminate()
              end,
              desc = "stop debug",
            },
            ["<f10>"] = {
              callback = function()
                require("dap").step_over()
              end,
              desc = "step over",
            },
            ["<f11>"] = {
              callback = function()
                require("dap").step_into()
              end,
              desc = "step into",
            },
            ["<s-f11>"] = {
              callback = function()
                require("dap").step_out()
              end,
              desc = "step out",
            },
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
