return {
  "nvim-tree/nvim-tree.lua",
  cmd = "NvimTreeFindFile",
  opts = {
    on_attach = function(bn)
      local api = require("nvim-tree.api")
      local set = function(k, a, d)
        vim.keymap.set("n", k, a, {
          desc = "nvim-tree: " .. d,
          buffer = bn,
          noremap = true,
          silent = true,
          nowait = true,
        })
      end
      set("?", api.tree.toggle_help, "help")
      set("q", api.tree.close, "quit")
      set("i", api.node.show_info_popup, "stat")
      set("h", api.node.navigate.parent_close, "close")
      set("l", api.node.open.no_window_picker, "open")
      set("<cr>", api.node.open.no_window_picker, "open")
      set("a", api.fs.create, "new")
      set("r", api.fs.rename, "rename")
      set("d", api.fs.remove, "delete")
    end,
    sync_root_with_cwd = true,
    view = {
      side = "right",
      signcolumn = "no",
    },
    renderer = {
      root_folder_label = false,
      icons = {
        show = {
          git = false,
          modified = false,
          diagnostics = false,
        },
        glyphs = {
          folder = {
            arrow_closed = " ",
            arrow_open = " ",
          },
        },
      },
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  },
  specs = {
    {
      "sunn4room/common.nvim",
      opts = {
        mappings = {
          n = {
            ["<cr>f"] = { command = "<cmd>NvimTreeFindFile<cr>", desc = "explore" },
          },
        },
        highlights = {
          Directory = { fg = 4 },
          NvimTreeFileName = { fg = 7 },
          NvimTreeFileIcon = { fg = 7 },
          NvimTreeHiddenFileHL = { fg = 7 },
          NvimTreeHiddenFolderHL = { fg = 6 },
          NvimTreeHiddenIcon = { fg = 4 },
          NvimTreeFolderName = { fg = 6 },
          NvimTreeFolderIcon = { fg = 6 },
          NvimTreeEmptyFolderName = { fg = 6 },
          NvimTreeEmptyFolderIcon = { fg = 6 },
          NvimTreeSymlink = { fg = 7 },
          NvimTreeSymlinkIcon = { fg = 7 },
          NvimTreeSymlinkFolderName = { fg = 6 },
        },
      },
    },
  },
}
