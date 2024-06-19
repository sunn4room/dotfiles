return {
  {
    "markdown-preview.nvim",
    url = "https://gitee.com/sunn4mirror/markdown-preview.nvim.git",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
