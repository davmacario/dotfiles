return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    -- No vim.cmd because I want to see the command written in the Vim command line
		vim.keymap.set("n", "<leader>gps", ":Git push", { noremap = true })
		vim.keymap.set("n", "<leader>gpu", ":Git pull -p", { noremap = true })
	end,
}
