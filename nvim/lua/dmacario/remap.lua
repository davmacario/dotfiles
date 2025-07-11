local api = vim.api
local keymap = vim.keymap.set
local utils = require("dmacario.utils")
-- Key mappings

vim.g.mapleader = " "

keymap("n", "<leader>pv", vim.cmd.Ex)

keymap("n", ",", "za", { desc = "Code folding with comma" })

-- Split view
keymap("n", "<leader>v", vim.cmd.vsplit)
keymap("n", "<leader>s", vim.cmd.split)
keymap(
	"n",
	"<leader>bq",
	":bp|bd#<CR>",
	{ noremap = true, silent = true, desc = "Close current buffer without losing split" }
)

-- Navigating split view
keymap("n", "<leader>h", "<C-w>h")
keymap("n", "<leader>l", "<C-w>l")
keymap("n", "<leader>j", "<C-w>j")
keymap("n", "<leader>k", "<C-w>k")
-- Jump to last in direction
keymap("n", "<leader>L", function()
	local wins = api.nvim_tabpage_list_wins(0)
	api.nvim_set_current_win(wins[#wins])
end)
keymap("n", "<leader>H", function()
	local wins = api.nvim_tabpage_list_wins(0)
	api.nvim_set_current_win(wins[1])
end)

-- Remap keys for resizing splits
keymap("n", "<C-Right", "<C-w>2>", { desc = "Increase window width" })
keymap("n", "<C-Left>", "<C-w>2<lt>", { desc = "Decrease window width" })
keymap("n", "<C-Up>", "<C-w>2+", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<C-w>2-", { desc = "Decrease window height" })

-- Remap keys for navigating buffers
keymap("n", "H", vim.cmd.bp)
keymap("n", "L", vim.cmd.bn)

-- Move selected lines while in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Movement
-- Keep cursor at center of page when jumping
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor at center when moving to next/previous occurrence
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Stay in visual mode when indenting
keymap("v", ">", ">gv")
keymap("v", "<", "<gv")

-- Copy-pasting
keymap("x", "<leader>p", "pgvy", { desc = "Paste with <leader>p to overwrite without losing yanked text" })
keymap("n", "<leader>y", '"+y', { desc = "<leader>y to yank to system clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "<leader>y to yank selection to system clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "<leader>Y to yank until end of line to system clipboard" })
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Utilities
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })
keymap("n", "<leader>R", ":%s/<C-r><C-w>/<C-r><C-w>/gc<C-f>$F/i", { desc = "Replace word under cursor" })
keymap("x", "<leader>R", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "Replace word under cursor" })

-- Quickfix list navigation
keymap("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Navigate to next item in quickfix list" })
keymap("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Navigate to previous item in quickfix list" })

-- ToDo list
keymap("n", "<leader>td", "o<CR><ESC>kkA TODO:<ESC>jjA - [ ]<ESC>kk0d^j.j.A", { desc = "Add a TODO comment" })
keymap("n", "<leader>md", "0f[lrx", { desc = "Mark Done" })
keymap("n", "<leader>rm", "0f[lr ", { desc = "Remove checkMark" })
keymap("n", "<leader>to", "o- [ ] ", { desc = "Open new TODO: item below current line" })
keymap("n", "<leader>tO", "O- [ ] ", { desc = "Open new TODO: item below current line" })

-- Session management
keymap("n", "<leader>se", function()
	local session_name = utils.git_branch_session_name()
	vim.cmd("mksession! " .. session_name)
	vim.print("Created " .. session_name)
end, { desc = "Create Vim session file with git branch name (if inside Git repo)" })

keymap("n", "<leader>sr", function()
	local session_name = utils.git_branch_session_name()
	local out = vim.system({ "rm", session_name })
	if vim.v.shell_error ~= 0 then -- FIXME: not working...
		print("Unable to delete session file " .. session_name .. ". " .. out)
	else
		print("Session file deleted successfully")
	end
end, { desc = "Remove Vim session file for current branch" })
