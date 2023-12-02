vim.g.mapleader = ' '

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Code folding with space
vim.keymap.set("n", ",", "za")

-- Navigating split view
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")

vim.keymap.set("n", "<leader>v", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>s", vim.cmd.split)

-- Remap keys for navigating tabs
vim.keymap.set("n", "H", ":bp<CR>")
vim.keymap.set("n", "L", ":bn<CR>")

-- Move selected lines while in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor at center of page when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor at center when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste with <leader>p to overwrite without losing yanked text
vim.keymap.set("x", "<leader>p", "\"_dP")

