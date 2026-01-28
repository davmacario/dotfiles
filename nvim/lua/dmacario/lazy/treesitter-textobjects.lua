return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	lazy = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-treesitter.config").setup({
			textobjects = {
				select = {
					enable = true,

					lookahead = true,

					-- define keymaps: to use them, enter operator ("v", "d", "c", "y") + the keys
					keymaps = {
						-- ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						-- ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						-- ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
						-- ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
					},
				},
			},
		})
	end,
}
