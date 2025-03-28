return {
  "yetone/avante.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  build = "make",
  opts = {
    provider = "qwen",
    auto_suggestions_provider = "qwen",
    vendors = {
      qwen = {
        __inherited_from = "openai",
        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
        model = "qwen2.5-coder-32b-instruct",
        api_key_name = "cmd:cat " .. vim.fn.expand("~/.config/QWEN_API_KEY"),
        max_tokens = 8192,
      },
    },
  },
}
