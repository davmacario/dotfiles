return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
		opts = {
			rocks = {
				hererocks = false,
			},
		},
	},
	{
		"nvim-lua/plenary.nvim",
		name = "plenary",
		dependencies = { "vhyrro/luarocks.nvim" },
	},
	"vim-airline/vim-airline-themes",
	"nvim-tree/nvim-web-devicons",
	"romgrk/barbar.nvim",
	"stevearc/dressing.nvim",
	"Vimjas/vim-python-pep8-indent",
	"simrat39/rust-tools.nvim",
}
