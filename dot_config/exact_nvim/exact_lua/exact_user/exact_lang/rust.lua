local get_build_target = function(is_test)
  is_test = is_test or false
  local file = vim.fn.expand("%:p")
  local build_cmd = { "cargo", "build", "--quiet", "--message-format", "json" }
  if is_test then
    table.insert(build_cmd, 3, "--tests")
  end
  local target = nil
  local results = vim.fn.systemlist(build_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("cargo build failed", vim.log.levels.ERROR)
    return target
  end
  for _, result in ipairs(results) do
    local json = vim.fn.json_decode(result)
    if
        type(json) == "table"
        and json.reason == "compiler-artifact"
        and json.executable ~= nil
        and json.target.src_path == file
        and json.profile.test == is_test
    then
      target = json.executable
      break
    end
  end
  return target
end

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
        rust = {
          {
            type = "lldb",
            request = "launch",
            name = "main",
            program = function()
              return get_build_target(false) or require("dap").ABORT
            end,
            args = function()
              local input = vim.fn.input("args: ", vim.b.run_args or "")
              vim.b.run_args = input
              return vim.fn.split(input, " ")
            end,
          },
          {
            type = "lldb",
            request = "launch",
            name = "test",
            program = function()
              return get_build_target(true) or require("dap").ABORT
            end,
            args = function()
              local input = vim.fn.input("args: ", vim.b.run_args or "")
              vim.b.run_args = input
              return vim.fn.split(input, " ")
            end,
          },
        },
      },
      type_to_filetypes = {
        lldb = {
          rust = true,
        },
      },
    },
  },
}
