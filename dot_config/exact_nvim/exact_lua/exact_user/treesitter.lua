return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    { "nvim-treesitter/playground" },
  },
  opts = {
    ensure_installed = {
      vim = true,
      vimdoc = true,
      lua = true,
      bash = true,
      markdown = true,
      markdown_inline = true,
      query = true,
    },
    highlight = {
      enable = true,
    },
    playground = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.install").prefer_git = true
    local ensure_installed = {}
    for k, v in pairs(opts.ensure_installed) do
      if v then
        table.insert(ensure_installed, k)
      end
    end
    opts.ensure_installed = ensure_installed
    require("nvim-treesitter.configs").setup(opts)
  end,
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["\\t"] = { command = "<cmd>TSPlaygroundToggle<cr>", desc = "treesitter" },
          },
        },
      },
    },
  },
}
