return {
  "ibhagwan/fzf-lua",
  keys = {
    { "sf", function() require("fzf-lua").files() end },
    { "sw", function() require("fzf-lua").live_grep() end },
    { "sh", function() require("fzf-lua").helptags() end },
  },
  opts = {},
}
