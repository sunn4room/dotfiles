return {
  "mfussenegger/nvim-dap",
  opts = {
    adapters = {
      lldb = {
        type = "executable",
        command = "lldb-vscode",
      },
    },
  },
}
