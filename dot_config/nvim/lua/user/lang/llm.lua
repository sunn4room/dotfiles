return {
  "yetone/avante.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  build = "make",
  opts = {
    provider = "qwen_32b",
    auto_suggestions_provider = "qwen_3b",
    vendors = {
      qwen_3b = {
        __inherited_from = "openai",
        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
        model = "qwen2.5-coder-3b-instruct",
        api_key_name = "cmd:cat " .. vim.fn.expand("~/.config/QWEN_API_KEY"),
        max_tokens = 8192,
      },
      qwen_32b = {
        __inherited_from = "openai",
        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
        model = "qwen2.5-coder-32b-instruct",
        api_key_name = "cmd:cat " .. vim.fn.expand("~/.config/QWEN_API_KEY"),
        max_tokens = 8192,
      },
    },
    behaviour = {
      auto_suggestions = true,
    },
  },
}
