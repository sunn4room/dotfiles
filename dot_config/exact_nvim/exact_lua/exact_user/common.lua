return {
  "sunn4room/common.nvim",
  opts = {
    options = {
      wrap = false,
      list = true,
      listchars = {
        tab = "<-",
        trail = "~",
        extends = ">",
        precedes = "<",
      },
      laststatus = 3,
      showtabline = 2,
      number = false,
      signcolumn = "no",
      foldcolumn = "0",
      termguicolors = function()
        return vim.fn.has("gui_running") ~= 0
      end,
      virtualedit = "onemore",
    },
    mappings = {
      n = {
        ["<cr>p"] = { command = "<cmd>Lazy<cr>", desc = "lazy" },
        ["g0"] = {
          callback = function()
            vim.bo.expandtab = false
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
          end,
          desc = "use tab",
        },
        ["g2"] = {
          callback = function()
            vim.bo.expandtab = true
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
            vim.bo.softtabstop = 2
          end,
          desc = "use space 2",
        },
        ["g4"] = {
          callback = function()
            vim.bo.expandtab = true
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
          end,
          desc = "use space 4",
        },
        ["<bs>v"] = { command = "<cmd>qall<cr>", desc = "quit" },
        ["<cr>w"] = { command = "<cmd>w<cr>", desc = "save" },
        u = { command = "u", desc = "redo" },
        U = { command = "<c-r>", desc = "undo" },
        ["[c"] = { command = "<c-o>", desc = "older cursor" },
        ["]c"] = { command = "<c-i>", desc = "newer cursor" },
        ["]x"] = { command = "<cmd>cn<cr>", desc = "next qf" },
        ["[x"] = { command = "<cmd>cp<cr>", desc = "prev qf" },
        ["<bs>x"] = { command = "<cmd>ccl<cr>", desc = "del qf" },
        ["<bs>b"] = { command = "<cmd>bd<cr>", desc = "del buffer" },
        ["]b"] = { command = "<cmd>bn<cr>", desc = "next buffer" },
        ["[b"] = { command = "<cmd>bp<cr>", desc = "prev buffer" },
        ["<cr>t"] = { command = "<cmd>tab sb<cr>", desc = "new tab" },
        ["<bs>t"] = { command = "<cmd>tabc<cr>", desc = "del tab" },
        ["]t"] = { command = "<cmd>tabn<cr>", desc = "next tab" },
        ["[t"] = { command = "<cmd>tabp<cr>", desc = "prev tab" },
        ["<cr>H"] = { command = "<cmd>aboveleft vs<cr>", desc = "split left" },
        ["<cr>L"] = { command = "<cmd>belowright vs<cr>", desc = "split right" },
        ["<cr>J"] = { command = "<cmd>belowright sp<cr>", desc = "split below" },
        ["<cr>K"] = { command = "<cmd>aboveleft sp<cr>", desc = "split above" },
        ["<bs>w"] = { command = "<cmd>q<cr>", desc = "del window" },
        ["<cr>h"] = { command = "<C-w>h", desc = "left window" },
        ["<cr>l"] = { command = "<C-w>l", desc = "right window" },
        ["<cr>j"] = { command = "<C-w>j", desc = "below window" },
        ["<cr>k"] = { command = "<C-w>k", desc = "above window" },
        ["<c-j>"] = { command = "<c-e>", desc = "scroll down" },
        ["<c-k>"] = { command = "<c-y>", desc = "scorll up" },
        ["<c-h>"] = { command = "2zh", desc = "scroll left" },
        ["<c-l>"] = { command = "2zl", desc = "scroll right" },
        ["<c-v>"] = { command = "\"+P", desc = "paste" },
        gz = { command = "g`\"", desc = "last position" },
        ["<cr>s"] = { command = "<cmd>tabnew term://bash<cr>i", desc = "shell" },
      },
      i = {
        ["<c-v>"] = { command = "<cmd>set paste<cr><c-r>+<cmd>set nopaste<cr>", desc = "paste" },
      },
      v = {
        ["<c-x>"] = { command = "\"+d", desc = "cut" },
        ["<c-c>"] = { command = "\"+y", desc = "copy" },
        ["<c-v>"] = { command = "\"+p", desc = "paste" },
      },
      t = {
        ["<esc><esc>"] = { command = "<c-\\><c-n>", desc = "normal mode" },
      },
      nxo = {
        H = { command = "^", desc = "start of line" },
        L = { command = "$", desc = "end of line" },
      },
    },
    autocmds = {
      auto_fcitx5_switch = function()
        vim.system { "pgrep", "fcitx5" }
        if vim.v.shell_error == 0 then
          return {
            {
              event = "InsertLeave",
              command = "silent !fcitx5-remote -c",
            },
          }
        else
          return {}
        end
      end,
      jump_last_position = {
        {
          event = "BufReadPost",
          pattern = "*",
          command = "silent! normal! g`\"zv",
        },
      },
      autoclose_bash = {
        {
          event = "TermClose",
          pattern = "term://*:bash",
          callback = function()
            vim.api.nvim_input("<CR>")
          end,
        },
      },
    },
    highlights = {
      Normal = { fg = 7, bg = 0 },
      NormalNC = "Normal",
      SpecialKey = { fg = 4 },
      NonText = { fg = 8 },
      Whitespace = "NonText",
      CursorLine = { bg = 8 },
      CursorColumn = "CursorLine",
      WinSeparator = { fg = 7, bg = 0, bold = true },
      StatusLine = { bg = 8, fg = 15, bold = true },
      TabLine = "StatusLine",
      TabLineFill = "TabLine",
      TabLineSel = "TabLine",
      Visual = { bg = 8 },
      Search = { bg = 8 },
      CurSearch = "Search",
      IncSearch = "Search",
      Substitute = "IncSearch",
      MatchParen = { underline = true },
      Cursor = { reverse = true },
      lCursor = "Cursor",
      CursorIM = "Cursor",
      TermCursor = "Cursor",
      TermCursorNC = "Cursor",
      ErrorMsg = { fg = 1, bold = true },
      WarningMsg = { fg = 3, bold = true },
      WarnMsg = "WarningMsg",
      InfoMsg = { fg = 2, bold = true },
      DebugMsg = { fg = 6, bold = true },
      TraceMsg = { fg = 4, bold = true },
      Title = { fg = 5, bold = true },
      TitleMsg = "Title",
      MoreMsg = { fg = 4 },
      MsgArea = "Normal",
      ModeMsg = { fg = 6 },
      Question = { fg = 5, bold = true },
      NormalFloat = "Normal",
      FloatBorder = "WinSeparator",
      FloatTitle = "FloatBorder",
      FloatFooter = "FloatTitle",
      Pmenu = "Normal",
      PmenuSel = { bg = 8, bold = true },
      PmenuKind = "Pmenu",
      PmenuKindSel = "PmenuSel",
      PmenuExtra = "Pmenu",
      PmenuExtraSel = "PmenuSel",
      PmenuSbar = "Pmenu",
      PmenuThumb = { fg = 7, bg = 7 },
      QuickFixLine = { bg = 8, bold = true },
      Comment = { fg = 4 },
      Constant = { fg = 3 },
      String = "Constant",
      Character = "Constant",
      Number = "Constant",
      Boolean = "Constant",
      Float = "Constant",
      Identifier = { fg = 7 },
      Function = "Identifier",
      Statement = { fg = 5 },
      Conditional = "Statement",
      Repeat = "Statement",
      Label = "Statement",
      Operator = "Statement",
      Keyword = "Statement",
      Exception = "Statement",
      PreProc = { fg = 4 },
      Include = "PreProc",
      Define = "PreProc",
      Macro = "PreProc",
      PreCondit = "PreProc",
      Type = { fg = 2 },
      StorageClass = "Type",
      Structure = "Type",
      Typedef = "Type",
      Special = { fg = 6 },
      SpecialChar = "Special",
      Tag = "Special",
      Delimiter = "Special",
      SpecialComment = "Special",
      Debug = "Special",
    },
  },
}
