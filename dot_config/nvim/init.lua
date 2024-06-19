local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local lazyrepo = "https://gitee.com/sunn4mirror/lazy.nvim.git"
local lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  local f = io.open(lockfile, "r")
  if f then
    local data = f:read("*a")
    local lock = vim.json.decode(data)
    local commit = lock["lazy.nvim"]["commit"]
    vim.fn.system { "git", "-C", lazypath, "checkout", commit }
    f:close()
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    {
      "lazy.nvim",
      url = lazyrepo,
      tag = "stable",
    },
    { import = "user" },
  },
  change_detection = {
    enabled = false,
  },
  install = {
    missing = true,
    colorscheme = { "default" },
  },
  ui = {
    border = "single",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
require("lazy.core.config").plugins["lazy.nvim"].url = lazyrepo
