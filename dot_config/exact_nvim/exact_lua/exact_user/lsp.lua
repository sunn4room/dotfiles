local progresses = {}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "nvimtools/none-ls.nvim", name = "null-ls" },
  },
  cmd = "LspStart",
  opts = function()
    return {
      default = {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities()
        ),
      },
      servers = {},
      configs = {},
      null_ls = {
        root_dir = require("null-ls.utils").root_pattern(".git"),
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.b[bufnr].formatting_client = client.name
          end
        end,
        sources = {},
      },
    }
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
    local null_ls = require("null-ls")
    for group, items in pairs(opts.null_ls.sources) do
      for name, option in pairs(items) do
        table.insert(
          opts.null_ls.sources,
          null_ls.builtins[group][name].with(option)
        )
      end
      opts.null_ls.sources[group] = nil
    end
    opts.null_ls.root_dir = require("null-ls.utils").root_pattern(".git")
    null_ls.setup(opts.null_ls)
    require("lspconfig.ui.windows").default_options.border = "rounded"
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
  end,
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>e"] = { command = "<cmd>LspStart<cr>", desc = "lsp" },
            ["]e"] = { callback = vim.diagnostic.goto_next, desc = "next diagnostic" },
            ["[e"] = { callback = vim.diagnostic.goto_prev, desc = "prev diagnostic" },
            ["K"] = { callback = vim.lsp.buf.hover, desc = "hover" },
            ["gd"] = { command = "<c-]>", desc = "goto definition" },
            ["gD"] = { callback = vim.lsp.buf.declaration, desc = "goto declaration" },
            ["gr"] = { callback = vim.lsp.buf.references, desc = "goto references" },
            ["gR"] = { callback = vim.lsp.buf.implementation, desc = "goto implementation" },
            ["<cr>v"] = { callback = vim.lsp.buf.rename, desc = "rename variable" },
          },
          nv = {
            ["gf"] = {
              callback = function()
                if vim.b.formatting_client ~= nil then
                  vim.lsp.buf.format { name = vim.b.formatting_client }
                else
                  vim.notify("No formatting client", 3)
                end
              end,
              desc = "format",
            },
          },
        },
        autocmds = {
          format_on_save = { {
            event = "BufWritePre",
            pattern = "*",
            callback = function(ctx)
              if vim.b[ctx.buf].formatting_client ~= nil then
                vim.lsp.buf.format {
                  bufnr = ctx.buf,
                  name = vim.b[ctx.buf].formatting_client,
                }
              end
            end,
          } },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      opts = {
        diagnostic = {
          update = {
            "DiagnosticChanged",
            "BufEnter",
            callback = vim.schedule_wrap(function()
              vim.cmd([[redrawstatus]])
            end),
          },
          condition = function(self)
            self.errors = #vim.diagnostic.get(0,
              { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0,
              { severity = vim.diagnostic.severity.WARN })
            self.infos = #vim.diagnostic.get(0,
              { severity = vim.diagnostic.severity.INFO })
            self.hints = #vim.diagnostic.get(0,
              { severity = vim.diagnostic.severity.HINT })
            return self.errors + self.warnings + self.infos + self.hints ~= 0
          end,
          { provider = " " },
          {
            provider = function(self)
              if self.hints ~= 0 then
                return (" %d "):format(self.hints)
              else
                return ""
              end
            end,
            hl = "LineTrace",
          },
          {
            provider = function(self)
              if self.infos ~= 0 then
                return (" %d "):format(self.infos)
              else
                return ""
              end
            end,
            hl = "LineDebug",
          },
          {
            provider = function(self)
              if self.warnings ~= 0 then
                return (" %d "):format(self.warnings)
              else
                return ""
              end
            end,
            hl = "LineWarn",
          },
          {
            provider = function(self)
              if self.errors ~= 0 then
                return (" %d "):format(self.errors)
              else
                return ""
              end
            end,
            hl = "LineError",
          },
        },
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
              for _, percent in pairs(tokens) do
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
