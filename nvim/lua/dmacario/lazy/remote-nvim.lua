return {
	"amitds1997/remote-nvim.nvim",
	version = "*", -- Pin to GitHub releases
	dependencies = {
		"nvim-lua/plenary.nvim", -- For standard functions
		"nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
	},
	config = function()
    require("remote-nvim").setup({})
  end,
}
