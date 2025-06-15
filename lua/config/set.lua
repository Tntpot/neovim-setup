vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.updatetime = 50

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.hlsearch = false

-- This is to allow UndoTree to execute `diff` on Windows (which is FC)
local getOS = require("config.getOS")
if getOS.getName() == "Windows" then
	vim.g.undotree_DiffCommand = "FC"
end

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.undodir = os.getenv("HOME") .. "/.vim/undodir"
