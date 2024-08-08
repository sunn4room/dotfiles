local progresses = {}
vim.lsp.handlers["$/progress"] = function(_, res, ctx)
  local name = vim.lsp.get_client_by_id(ctx.client_id).name
  local token = tostring(res.token)
  if res.value.kind == "begin" then
    progresses[name] = progresses[name] or {}
    progresses[name][token] = 0
  elseif res.value.kind == "end" then
    progresses[name][token] = nil
  else
    progresses[name][token] = res.value.percentage
  end
  vim.cmd [[doautocmd User ProgressUpdate]]
end
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "rounded",
    silent = true,
  }
)
vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  signs = false,
  float = {
    border = "rounded",
  },
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "nvimtools/none-ls.nvim" },
  },
  cmd = "LspStart",
  opts = function(_, opts)
    opts.default = opts.default or {}
    opts.default.capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )
    opts.servers = opts.servers or {}
    opts.configs = opts.configs or {}
    opts.null_ls = opts.null_ls or {}
  end,
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    local lspconfig_util = require("lspconfig.util")
    lspconfig_util.default_config = vim.tbl_extend(
      "force",
      lspconfig_util.default_config,
      opts.default
    )
    local lspconfig_configs = require("lspconfig.configs")
    for k, v in pairs(opts.configs) do
      lspconfig_configs[k] = v
    end
    for k, v in pairs(opts.servers) do
      lspconfig[k].setup(v)
    end
    require("lspconfig.ui.windows").default_options.border = "rounded"
  end,
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>e"] = { command = "<cmd>LspStart<cr>", desc = "lsp" },
          },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      opts = {
        lsp = {
          update = {
            "LspAttach",
            "LspDetach",
            callback = vim.schedule_wrap(function()
              vim.cmd([[redrawstatus]])
            end),
          },
          condition = function(self)
            local names = {}
            for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
              table.insert(names, server.name)
            end
            self.names = names
            return #self.names ~= 0
          end,
          { provider = " ", hl = "LineSpecial" },
          {
            provider = function(self)
              return " " .. table.concat(self.names, ",") .. " "
            end,
          },
        },
        progress = {
          update = {
            "User",
            pattern = "ProgressUpdate",
            callback = function()
              vim.schedule(vim.cmd.redrawtabline)
            end,
          },
          condition = function(self)
            local str = ""
            for name, tokens in pairs(progresses) do
              local total = 0
              local count = 0
              for token, percent in pairs(tokens) do
                count = count + 1
                total = total + percent
              end
              if count ~= 0 then
                str = str .. ("%s:%d,"):format(name, math.floor(total / count))
              end
            end
            if #str ~= 0 then
              self.progresses = str:sub(1, -2)
              return true
            else
              return false
            end
          end,
          { provider = " ", hl = "LineSpecial" },
          {
            provider = function(self)
              return " " .. self.progresses .. " "
            end,
          },
        },
      },
    },
  },
}
