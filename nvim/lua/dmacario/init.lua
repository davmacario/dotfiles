print("Welcome back!")

require("dmacario.remap")
require("dmacario.set")
require("dmacario.lazy_init")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
