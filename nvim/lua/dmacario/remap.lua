-- Key mappings

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", ",", "za", { desc = "Code folding with comma" })

-- Split view
vim.keymap.set("n", "<leader>v", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>s", vim.cmd.split)

-- Navigating split view
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")

-- Remap keys for resizing splits
vim.keymap.set("n", "<leader>>", "<C-w>2>")
vim.keymap.set("n", "<leader><lt>", "<C-w>2<lt>")
vim.keymap.set("n", "<leader>+", "<C-w>2+")
vim.keymap.set("n", "<leader>-", "<C-w>2-")

-- Remap keys for navigating tabs
vim.keymap.set("n", "H", ":bp<CR>")
vim.keymap.set("n", "L", ":bn<CR>")

-- Move selected lines while in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Movement
-- Keep cursor at center of page when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor at center when moving to next/previous occurrence
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Copy-pasting
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste with <leader>p to overwrite without losing yanked text" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "<leader>y to yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "<leader>y to yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "<leader>Y to yank until end of line to system clipboard" })

-- Utilities
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })
vim.keymap.set("n", "<leader>R", ":%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/i", { desc = "Replace word under cursor" })

-- ToDo list
vim.keymap.set(
	"n",
	"<leader>td",
	"o<CR><CR><CR><ESC>kkiTODO:<ESC><cmd>CBllline13<CR>o<CR> - [ ] ",
	{ desc = "Add a TODO comment" }
)
vim.keymap.set("n", "<leader>md", "0f[lrx", { desc = "Mark Done" })
vim.keymap.set("n", "<leader>rm", "0f[lr ", { desc = "Remove checkMark" })
vim.keymap.set("n", "<leader>to", "o- [ ] ", { desc = "Open new TODO: item below current line" })
vim.keymap.set("n", "<leader>tO", "O- [ ] ", { desc = "Open new TODO: item below current line" })
