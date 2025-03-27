vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("NvimDapLoaded", {}),
  pattern = "LazyLoad",
  callback = function(e)
    if e.data == "nvim-dap" then
      vim.cmd("do User NvimDapLoaded")
    end
  end,
})

local function float_dapui_element(id)
  local dapui = require("dapui")
  dapui.float_element(id, {
    width = 0.6,
    height = 0.6,
    enter = true,
    title = "[dapui] " .. id,
    position = "center",
  })
end

return {
  "mfussenegger/nvim-dap",
  lazy = true,
  keys = {
    { "yc",  function() require("dap").toggle_breakpoint() end },
    { "yC",  function() require("dap").set_breakpoint() end },
    { "ym",  function() require("dap").continue() end },
    { "yMs", function() float_dapui_element("scopes") end },
    { "yMt", function() float_dapui_element("stacks") end },
    { "yMe", function() float_dapui_element("watches") end },
    { "yMc", function() float_dapui_element("breakpoints") end },
    { "yMv", function() require("dapui").eval() end },
    { "gm",  function() require("dap").step_over() end },
    { "g,",  function() require("dap").step_into() end },
    { "g.",  function() require("dap").step_out() end },
    { "dm",  function() require("dap").terminate() end },
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      lazy = true,
      main = "dapui",
      dependencies = {
        { "nvim-neotest/nvim-nio" },
      },
      opts = {
        controls = {
          enabled = false,
        },
        layouts = {
          {
            position = "bottom",
            size = 10,
            elements = {
              {
                id = "console",
                size = 1.0,
              },
            },
          },
        },
        floating = {
          border = "rounded",
        },
      },
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

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

    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 8 })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { ctermbg = 8 })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 6, ctermfg = 0 })
  end,
}
