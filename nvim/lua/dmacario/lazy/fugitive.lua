return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
		vim.keymap.set("n", "<leader>gps", function()
			vim.cmd("Git push")
		end, { noremap = true })
		vim.keymap.set("n", "<leader>gpu", function()
			vim.cmd("Git pull -p")
		end, { noremap = true })
	end,
}
