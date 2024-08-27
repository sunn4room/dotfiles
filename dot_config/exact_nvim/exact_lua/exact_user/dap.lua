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
    local fifo = "/tmp/dap_fifo"
    vim.fn.system { "rm", "-f", fifo }
    vim.fn.system { "mkfifo", fifo }
    dap.listeners.after.event_initialized["dapui_config"] = function()
      vim.cmd("belowright 10split term://tail\\ -f\\ " .. fifo)
      vim.cmd("normal G")
      vim.cmd("setlocal nobuflisted")
      vim.cmd("wincmd p")
      dap.repl.open(nil, "belowright 40vsplit")
      vim.cmd("wincmd l")
      vim.cmd("startinsert")
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dap.repl.close()
      vim.cmd("wincmd b")
      local pid = vim.fn.expand("%")
          :match("%d+:tail %-f /tmp/dap_fifo$")
          :sub(1, -23)
      vim.fn.system { "kill", "-s", "SIGINT", pid }
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dap.repl.close()
      vim.cmd("wincmd b")
      local pid = vim.fn.expand("%")
          :match("%d+:tail %-f /tmp/dap_fifo$")
          :sub(1, -23)
      vim.fn.system { "kill", "-s", "SIGINT", pid }
    end
    dap.defaults.fallback.on_output = function(_, body)
      if body.category == "stdout" or body.category == "stderr" then
        local fifof = io.open(fifo, "w")
        if fifof then
          fifof:write(body.output)
          fifof:close()
        end
      end
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
            ["\\d"] = {
              callback = function()
                local bufnr = vim.fn.bufnr()
                vim.b[bufnr].breakpoints = nil
                local linenr, _ = unpack(vim.api.nvim_win_get_cursor(0))
                local bps = require("dap.breakpoints").get()
                if bps[bufnr] then
                  for _, bp in ipairs(bps[bufnr]) do
                    if bp.line == linenr then
                      require("dap").toggle_breakpoint()
                      return
                    end
                  end
                end
                require("dap").set_breakpoint(
                  vim.fn.input("Breakpoint condition: ")
                )
              end,
              desc = "toggle breakpoint",
            },
            ["\\D"] = {
              callback = function()
                local dbps = require("dap.breakpoints")
                local bufnr = vim.fn.bufnr()
                if vim.b[bufnr].breakpoints then
                  for _, bp in ipairs(vim.b[bufnr].breakpoints) do
                    dbps.set(bp, bufnr, bp.line)
                  end
                  vim.b[bufnr].breakpoints = nil
                else
                  local bps = dbps.get()
                  if bps[bufnr] then
                    vim.b[bufnr].breakpoints = bps[bufnr]
                    for _, bp in ipairs(bps[bufnr]) do
                      dbps.remove(bufnr, bp.line)
                    end
                  end
                end
              end,
              desc = "set condition breakpoint",
            },
            ["<cr>d"] = {
              callback = function()
                require("dap").continue()
              end,
              desc = "start debug",
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
