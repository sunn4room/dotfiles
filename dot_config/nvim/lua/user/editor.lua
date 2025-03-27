vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.opt.number = false
vim.opt.wrap = false
vim.opt.signcolumn = "no"
vim.opt.foldcolumn = "0"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = false
vim.opt.list = true
vim.opt.listchars = {
	tab = "<-",
	trail = "~",
	extends = ">",
	precedes = "<",
}
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

vim.keymap.set("n", "u", "u")
vim.keymap.set("n", "U", "<c-r>")
vim.keymap.set("n", "gu", "<c-o>")
vim.keymap.set("n", "gU", "<c-i>")
vim.keymap.set("n", "yb", ":e")
vim.keymap.set("n", "cb", "<cmd>w<cr>")
vim.keymap.set("n", "db", "<cmd>bd<cr>")
vim.keymap.set("n", "gb", "<cmd>bn<cr>")
vim.keymap.set("n", "gB", "<cmd>bp<cr>")
vim.keymap.set("n", "yt", ":tabe")
vim.keymap.set("n", "dt", "<cmd>tabc<cr>")
vim.keymap.set("n", "gt", "<cmd>tabn<cr>")
vim.keymap.set("n", "gT", "<cmd>tabp<cr>")
vim.keymap.set("n", "yh", ":aboveleft vs")
vim.keymap.set("n", "yl", ":belowright vs")
vim.keymap.set("n", "yj", ":belowright sp")
vim.keymap.set("n", "yk", ":aboveleft sp")
vim.keymap.set("n", "gh", "<C-w>h")
vim.keymap.set("n", "gl", "<C-w>l")
vim.keymap.set("n", "gj", "<C-w>j")
vim.keymap.set("n", "gk", "<C-w>k")
vim.keymap.set("n", "dw", "<cmd>q<cr>")
vim.keymap.set("n", "dh", "<cmd>noh<cr>")

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("RestoreLastPosition", {}),
	pattern = "*",
	command = "silent! normal! g`\"zv",
})
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("AutoInsertTerm", {}),
	pattern = "term://*",
	callback = function()
		vim.api.nvim_input("i")
	end,
})
vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("AutoCloseTerm", {}),
	pattern = { "term://*:bash", "term://*:lazygit" },
	callback = function()
		vim.api.nvim_input("<CR>")
	end,
})

vim.api.nvim_set_hl(0, "Visual", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "Search", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "CurSearch", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 8 })
vim.api.nvim_set_hl(0, "NonText", { ctermfg = 8 })
vim.api.nvim_set_hl(0, "SpecialKey", { ctermfg = 4 })

return {}
