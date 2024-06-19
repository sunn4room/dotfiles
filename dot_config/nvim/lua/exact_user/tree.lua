return {
  {
    "nvim-tree.lua",
    url = "https://gitee.com/sunn4mirror/nvim-tree.lua.git",
    cmd = "NvimTreeFindFile",
    opts = {
      hijack_cursor = true,
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end
        vim.keymap.set("n", "l", api.node.open.no_window_picker, opts("open"))
        vim.keymap.set("n", "<cr>", api.node.open.no_window_picker, opts("open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("close"))
        vim.keymap.set("n", "a", api.fs.create, opts("create"))
        vim.keymap.set("n", "d", api.fs.remove, opts("remove"))
        vim.keymap.set("n", "r", api.fs.rename, opts("rename"))
        vim.keymap.set("n", "y", api.fs.copy.node, opts("copy"))
        vim.keymap.set("n", "c", api.fs.cut, opts("cut"))
        vim.keymap.set("n", "p", api.fs.paste, opts("paste"))
        vim.keymap.set("n", "w", api.tree.change_root_to_node, opts("cwd"))
        vim.keymap.set("n", "R", api.tree.reload, opts("reload"))
        vim.keymap.set("n", "q", api.tree.close, opts("quit"))
      end,
      view = {
        signcolumn = "no",
        width = 30,
      },
      renderer = {
        icons = {
          show = {
            folder_arrow = false,
            git = false,
            modified = false,
            diagnostics = false,
          },
        },
      },
      actions = {
        change_dir = {
          enable = true,
          global = true,
        },
        open_file = {
          quit_on_open = false,
        },
      },
    },
  },
  {
    "common.nvim",
    opts = {
      mappings = {
        n = {
          yf = "<cmd>NvimTreeFindFile<CR>",
          df = "<cmd>NvimTreeClose<CR>",
        },
      },
    },
  },
}
