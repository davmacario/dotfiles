return {
	"davmacario/nvim-quicknotes",
	cmd = { "Quicknotes", "QuicknotesClear", "QuicknotesCleanup" },
	config = function()
		require("nvim-quicknotes").setup()
		vim.keymap.set("n", "<leader>qn", vim.cmd.Quicknotes, { desc = "Open quicknotes" })
	end,
}
