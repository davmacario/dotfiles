return {
	"lewis6991/gitsigns.nvim",
	dependencies = {
		"tpope/vim-fugitive",
	},
	config = function()
		local icons = require("dmacario.style.icons")
		require("gitsigns").setup({
			signs = icons.gitsigns,
		})
	end,
}
