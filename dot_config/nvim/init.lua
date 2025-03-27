local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Unable to clone lazy.nvim repository.\n", "ErrorMsg" },
      { "Press any key to exit...",                "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
  local lazylock = io.open(vim.fn.stdpath("config") .. "/lazy-lock.json", "r")
  if lazylock then
    vim.fn.system {
      "git",
      "-C",
      lazypath,
      "checkout",
      vim.json.decode(lazylock:read("*a"))["lazy.nvim"]["commit"],
    }
    lazylock:close()
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    {
      "folke/lazy.nvim",
      branch = "stable",
    },
    { import = "user" },
    { import = "user.lang" },
  },
  install = { colorscheme = { "default" } },
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
}
