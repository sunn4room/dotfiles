local format_on_save = function(bufnr, name)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format { bufnr = bufnr, name = name }
    end,
  })
end

return {
  {
    "nvim-lspconfig",
    url = "https://gitee.com/sunn4mirror/nvim-lspconfig.git",
    dependencies = {
      {
        "cmp-nvim-lsp",
        url = "https://gitee.com/sunn4mirror/cmp-nvim-lsp.git",
      },
      {
        "none-ls.nvim",
        url = "https://gitee.com/sunn4mirror/none-ls.nvim.git",
        dependencies = { "plenary.nvim" },
      },
      {
        "nvim-jdtls",
        url = "https://gitee.com/sunn4mirror/nvim-jdtls.git",
        enabled = false,
        config = function()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "java" },
            callback = function()
              require("jdtls").start_or_attach {
                cmd = {
                  "/usr/bin/jdtls",
                },
                root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
              }
            end,
          })
        end,
      },
    },
    cmd = "LspStart",
    opts = {
      default = {
        autostart = false,
        flags = {
          debounce_text_changes = 500,
        },
        capabilities = function()
          return vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities(),
            require("lsp-file-operations").default_capabilities()
          )
        end,
      },
      lsp = {
        lua_ls = {
          condition = function()
            return vim.fn.executable("lua-language-server") == 1
          end,
          on_attach = function(_, bufnr)
            format_on_save(bufnr, "lua_ls")
          end,
        },
        rust_analyzer = {
          condition = function()
            return vim.fn.executable("rust-analyzer") == 1
          end,
          on_attach = function(_, bufnr)
            format_on_save(bufnr, "rust_analyzer")
          end,
        },
        gopls = {
          condition = function()
            return vim.fn.executable("gopls") == 1
          end,
          on_attach = function(_, bufnr)
            format_on_save(bufnr, "gopls")
          end,
        },
        tsserver = {
          condition = function()
            return vim.fn.executable("typescript-language-server") == 1 and vim.fn.executable("vue-language-server") == 1
          end,
          filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.system({ "readlink", "/run/current-system/sw/bin/vue-language-server" }):sub(0, 25) ..
                    "lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
                languages = { "vue" },
              },
            }
          },
        },
        volar = {
          condition = function()
            return vim.fn.executable("typescript-language-server") == 1 and vim.fn.executable("vue-language-server") == 1
          end,
        },
        pyright = {
          condition = function()
            return vim.fn.executable("pyright") == 1
          end,
        },
        bashls = {
          condition = function()
            return vim.fn.executable("bash-language-server") == 1
          end,
        },
        taplo = {
          condition = function()
            return vim.fn.executable("taplo") == 1
          end,
          on_attach = function(_, bufnr)
            format_on_save(bufnr, "taplo")
          end,
        },
      },
      null_ls = {
        sources = {
          formatting = {
            prettier = {
              filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
              condition = function(utils)
                return utils.root_has_file { "node_modules/.bin/prettier" }
              end,
            },
            black = {
              condition = function()
                return vim.fn.executable("black") == 1
              end,
            },
            shfmt = {
              condition = function()
                return vim.fn.executable("shfmt") == 1
              end,
            },
          },
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            format_on_save(bufnr, "null-ls")
          end
        end,
      },
    },
    config = function(_, opts)
      if type(opts.default.capabilities) == "function" then
        opts.default.capabilities = opts.default.capabilities()
      end
      for k, o in pairs(opts.lsp) do
        if type(o.condition) ~= "function" or o.condition() then
          o.condition = nil
          require("lspconfig")[k].setup(
            vim.tbl_deep_extend("force", {}, opts.default, o)
          )
        end
      end
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = "single",
          silent = true,
        }
      )
      vim.diagnostic.config {
        underline = true,
        virtual_text = false,
        signs = false,
        float = {
          border = "single",
        },
      }
      local lsp_progress_titles = {}
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["$/progress"] = function(_, res, ctx)
        local id = ("%s.%s"):format(ctx.client_id, res.token)
        local level = 1
        if res.value.kind == "begin" then
          lsp_progress_titles[id] = res.value.title
          level = 3
        end
        local name = vim.lsp.get_client_by_id(ctx.client_id).name
        local percent = res.value.percentage or 0
        if res.value.kind == "end" then
          percent = 100
          level = 2
        end
        local message = lsp_progress_titles[id] ..
            (res.value.message and ": " .. res.value.message or "")
        vim.notify(("[%s] %d%% %s"):format(name, percent, message), level)
        if res.value.kind == "end" then
          lsp_progress_titles[id] = nil
        end
      end

      local null_ls = require("null-ls")
      for group, items in pairs(opts.null_ls.sources) do
        if type(group) == "string" then
          for k, v in pairs(items) do
            local kk = null_ls.builtins[group][k]
            if kk then
              table.insert(opts.null_ls.sources, kk.with(v))
            end
          end
          opts.null_ls.sources[group] = nil
        end
      end
      opts.null_ls.root_dir = require("null-ls.utils").root_pattern(".git")
      null_ls.setup(opts.null_ls)
    end,
  },
  {
    "heirline.nvim",
    opts = {
      statusline = {
        diagnostics = {
          condition = "is_active",
          {
            update = {
              "LspAttach",
              "LspDetach",
              callback = vim.schedule_wrap(function()
                vim.cmd([[redrawstatus]])
              end),
            },
            provider = function()
              local names = {}
              for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
                table.insert(names, server.name)
              end
              if #names == 0 then
                return ""
              else
                return " [" .. table.concat(names, ",") .. "] "
              end
            end,
          },
          {
            update = {
              "DiagnosticChanged",
              "BufEnter",
              callback = vim.schedule_wrap(function()
                vim.cmd([[redrawstatus]])
              end),
            },
            init = function(self)
              self.errors = #vim.diagnostic.get(0,
                { severity = vim.diagnostic.severity.ERROR })
              self.warnings = #vim.diagnostic.get(0,
                { severity = vim.diagnostic.severity.WARN })
              self.infos = #vim.diagnostic.get(0,
                { severity = vim.diagnostic.severity.INFO })
              self.hints = #vim.diagnostic.get(0,
                { severity = vim.diagnostic.severity.HINT })
            end,
            {
              provider = function(self)
                if self.hints == 0 then
                  return ""
                else
                  return string.format(" H%d", self.hints)
                end
              end,
              hl = "LineHint",
            },
            {
              provider = function(self)
                if self.infos == 0 then
                  return ""
                else
                  return string.format(" I%d", self.infos)
                end
              end,
              hl = "LineInfo",
            },
            {
              provider = function(self)
                if self.warnings == 0 then
                  return ""
                else
                  return string.format(" W%d", self.warnings)
                end
              end,
              hl = "LineWarn",
            },
            {
              provider = function(self)
                if self.errors == 0 then
                  return ""
                else
                  return string.format(" E%d", self.errors)
                end
              end,
              hl = "LineError",
            },
            {
              provider = function(self)
                if self.errors + self.warnings + self.infos + self.hints > 0 then
                  return " "
                else
                  return ""
                end
              end,
            },
          },
        },
      },
    },
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        n = {
          ye = "<cmd>LspStart<cr>",
          ge = function()
            vim.diagnostic.goto_next { float = false }
            vim.diagnostic.open_float { scope = "cursor" }
            vim.diagnostic.open_float { scope = "cursor" }
          end,
          gE = function()
            vim.diagnostic.goto_prev { float = false }
            vim.diagnostic.open_float { scope = "cursor" }
            vim.diagnostic.open_float { scope = "cursor" }
          end,
          gd = vim.lsp.buf.definition,
          gD = vim.lsp.buf.declaration,
          gr = vim.lsp.buf.references,
          gR = vim.lsp.buf.implementation,
          gi = vim.lsp.buf.incoming_calls,
          go = vim.lsp.buf.outgoing_calls,
          ga = function()
            vim.lsp.buf.code_actions {
              context = {
                only = {
                  "source",
                  "refactor",
                  "quickfix",
                },
              },
            }
          end,
          cf = vim.lsp.buf.format,
          cn = vim.lsp.buf.rename,
          K = function()
            vim.lsp.buf.hover()
            vim.lsp.buf.hover()
          end,
          --["<space>s"] = "<cmd>FzfLua lsp_live_workspace_symbols<cr>",
        },
        v = {
          --["<space>a"] = "<cmd>FzfLua lsp_code_actions<cr>",
          Cf = vim.lsp.buf.format,
        },
      },
    },
  },
}
