local api = vim.api
local utils = require("dmacario.utils")
-- Key mappings
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", ",", "za", { desc = "Code folding with comma" })

-- Split view
vim.keymap.set("n", "<leader>v", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>s", vim.cmd.split)
vim.keymap.set(
	"n",
	"<leader>bq",
	":bp|bd#<CR>",
	{ noremap = true, silent = true, desc = "Close current buffer without losing split" }
)

-- Navigating split view
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
-- Jump to last in direction
vim.keymap.set("n", "<leader>L", function()
	local wins = api.nvim_tabpage_list_wins(0)
	api.nvim_set_current_win(wins[#wins])
end)
vim.keymap.set("n", "<leader>H", function()
	local wins = api.nvim_tabpage_list_wins(0)
	api.nvim_set_current_win(wins[1])
end)

-- Remap keys for resizing splits
vim.keymap.set("n", "<leader>>", "<C-w>2>")
vim.keymap.set("n", "<leader><lt>", "<C-w>2<lt>")
vim.keymap.set("n", "<leader>+", "<C-w>2+")
vim.keymap.set("n", "<leader>=", "<C-w>2+") -- Not pressing shift, may change
vim.keymap.set("n", "<leader>-", "<C-w>2-")
vim.keymap.set("n", "<leader>_", "<C-w>2-") -- Force of habit

-- Remap keys for navigating tabs
vim.keymap.set("n", "H", vim.cmd.bp)
vim.keymap.set("n", "L", vim.cmd.bn)

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
vim.keymap.set("x", "<leader>p", "pgvy", { desc = "Paste with <leader>p to overwrite without losing yanked text" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "<leader>y to yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "<leader>y to yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "<leader>Y to yank until end of line to system clipboard" })

-- Utilities
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })
vim.keymap.set("n", "<leader>R", ":%s/<C-r><C-w>/<C-r><C-w>/gc<C-f>$F/i", { desc = "Replace word under cursor" })
vim.keymap.set("x", "<leader>R", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "Replace word under cursor" })

-- ToDo list
vim.keymap.set("n", "<leader>td", "o<CR><ESC>kkA TODO:<ESC>jjA - [ ]<ESC>kk0d^j.j.A", { desc = "Add a TODO comment" })
vim.keymap.set("n", "<leader>md", "0f[lrx", { desc = "Mark Done" })
vim.keymap.set("n", "<leader>rm", "0f[lr ", { desc = "Remove checkMark" })
vim.keymap.set("n", "<leader>to", "o- [ ] ", { desc = "Open new TODO: item below current line" })
vim.keymap.set("n", "<leader>tO", "O- [ ] ", { desc = "Open new TODO: item below current line" })

-- Session management
vim.keymap.set("n", "<leader>se", function()
	local session_name = utils.git_branch_session_name()
	vim.cmd("mksession! " .. session_name)
	vim.print("Created " .. session_name)
end, { desc = "Create Vim session file with git branch name (if inside Git repo)" })

vim.keymap.set("n", "<leader>sr", function()
	local session_name = utils.git_branch_session_name()
	local out = vim.system({ "rm", session_name })
	if vim.v.shell_error ~= 0 then -- FIXME: not working...
		print("Unable to delete session file " .. session_name .. ". " .. out)
	else
		print("Session file deleted successfully")
	end
end, { desc = "Remove Vim session file for current branch" })
