return {
  "yetone/avante.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  build = "make",
  event = "InsertEnter",
  cmd = {
    "AvanteAsk",
    "AvanteChat",
    "AvanteSwitchProvider",
  },
  init = function()
    vim.cmd([[cab ask AvanteAsk]])
    vim.cmd([[cab chat AvanteChat]])
    vim.cmd([[cab model AvanteSwitchProvider]])
  end,
  opts = {
    provider = "sf_deepseek_r1_7b",
    auto_suggestions_provider = "sf_qwen_coder_7b",
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
      cfw_deepseek_r1_32b = {
        __inherited_from = "openai",
        endpoint =
        "https://api.cloudflare.com/client/v4/accounts/b0fcc2a05b8c280ce13f3d1f279a0c29/ai/v1",
        model = "@cf/deepseek-ai/deepseek-r1-distill-qwen-32b",
        api_key_name = "cmd:cat " .. vim.fn.expand("~/.config/CFWAI_API_KEY"),
        reasoning_effort = "medium",
      },
      sf_deepseek_r1_7b = {
        __inherited_from = "openai",
        endpoint = "https://api.siliconflow.cn/v1",
        model = "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
        api_key_name = "cmd:cat " .. vim.fn.expand("~/.config/SF_API_KEY"),
        reasoning_effort = "medium",
      },
      sf_qwen_coder_7b = {
        __inherited_from = "openai",
        endpoint = "https://api.siliconflow.cn/v1",
        model = "Qwen/Qwen2.5-Coder-7B-Instruct",
        api_key_name = "cmd:cat " .. vim.fn.expand("~/.config/SF_API_KEY"),
        max_tokens = 4096,
      },
    },
    behaviour = {
      auto_suggestions = true,
    },
  },
}
