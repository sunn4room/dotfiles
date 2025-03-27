local client_notifs = {}
local function get_notif_data(client_id, token)
  if not client_notifs[client_id] then
    client_notifs[client_id] = {}
  end
  if not client_notifs[client_id][token] then
    client_notifs[client_id][token] = {}
  end
  return client_notifs[client_id][token]
end

local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
local function update_spinner(client_id, token)
  local notif_data = get_notif_data(client_id, token)
  if notif_data.spinner then
    notif_data.spinner = notif_data.spinner + 1
    if notif_data.spinner > #spinner_frames then
      notif_data.spinner = 1
    end
    notif_data.notification = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[notif_data.spinner],
      replace = notif_data.notification,
    })
    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client_name)
  return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
  return string.format("%3s%%  %s", tostring(percentage), message)
end

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id
  local client_name = vim.lsp.get_client_by_id(client_id).name
  if client_name == "null-ls" then return end
  local val = result.value
  local notif_data = get_notif_data(client_id, result.token)
  if val.kind == "begin" then
    notif_data.notification = vim.notify(
      format_message(val.message or "Processing", val.percentage or 0), 2, {
        title = format_title(val.title, client_name),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = false,
      })
    notif_data.spinner = 1
    update_spinner(client_id, result.token)
  elseif val.kind == "report" and notif_data then
    notif_data.notification = vim.notify(
      format_message(val.message or "Processing", val.percentage or 0), 2, {
        replace = notif_data.notification,
        hide_from_history = false,
      })
  elseif val.kind == "end" and notif_data then
    notif_data.notification = vim.notify(format_message(val.message or "Complete", 100), 2, {
      icon = "",
      replace = notif_data.notification,
      timeout = 3000,
    })
    notif_data.spinner = nil
  end
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded", silent = true }
)
vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  signs = false,
  float = {
    border = "rounded",
  },
}

vim.keymap.set("n", "ge", function() vim.diagnostic.goto_next() end)
vim.keymap.set("n", "gE", function() vim.diagnostic.goto_prev() end)
vim.keymap.set({ "n", "x" }, "<space>a", function() require("fzf-lua").lsp_code_actions() end)
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end)
vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end)
vim.keymap.set("n", "gR", function() vim.lsp.buf.implementation() end)
vim.keymap.set("n", "K", function()
  if require("lazy.core.config").plugins["nvim-dap"]._.loaded ~= nil and require("dap").session() ~= nil then
    require("dapui").eval()
  elseif vim.diagnostic.open_float { border = "rounded" } == nil then
    vim.lsp.buf.hover()
  end
end)
vim.keymap.set("n", "cn", function() vim.lsp.buf.rename() end)
vim.keymap.set({ "n", "v" }, "cf", function()
  if vim.b.formatting_client ~= nil then
    vim.lsp.buf.format { name = vim.b.formatting_client }
  else
    vim.notify("No formatting client", 3)
  end
end)

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", {}),
  pattern = "*",
  callback = function(ctx)
    if vim.b[ctx.buf].formatting_client ~= nil then
      vim.lsp.buf.format {
        bufnr = ctx.buf,
        name = vim.b[ctx.buf].formatting_client,
      }
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    main = "null-ls",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      sources = {},
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.b[bufnr].formatting_client = client.name
        end
      end,
    },
  },
}
