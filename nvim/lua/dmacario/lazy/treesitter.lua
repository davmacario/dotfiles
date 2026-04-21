-- NOTE: see autocmd.lua ('TreesitterConfigure') for set up
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter").setup({})
		require("nvim-treesitter").install({
			"c",
			"cpp",
			"python",
			"lua",
			"bash",
			"zsh",
			"dockerfile",
			"yaml",
			"markdown",
			"markdown_inline",
			"comment",
			"json",
			"rust",
			"go",
			"query",
			"hcl",
			"terraform",
			"html",
			"latex",
			"ini",
			"toml",
		})
	end,
}
