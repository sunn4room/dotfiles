return {
  {
    "markdown-preview.nvim",
    url = "https://gitee.com/sunn4mirror/markdown-preview.nvim.git",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npx --yes yarn install --registry https://registry.npmmirror.com/",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
