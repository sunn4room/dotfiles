return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<space>f", function() require("fzf-lua").files() end },
    { "<space>w", function() require("fzf-lua").live_grep() end },
    { "<space>h", function() require("fzf-lua").helptags() end },
  },
  opts = {},
}
