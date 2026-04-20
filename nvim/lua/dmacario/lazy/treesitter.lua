return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter").setup({})
		require("nvim-treesitter").install({
			"c",
			"cpp",
			"python",
			"lua",
			"bash",
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
		})
	end,
}
