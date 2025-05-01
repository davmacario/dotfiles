return {
	"mcauley-penney/visual-whitespace.nvim",
	commit = "compat-v10",
	config = function()
		require("visual-whitespace").setup({
			highlight = { fg = "#908070", bg = "#665c54" },
			space_char = "·",
			tab_char = "→",
			nl_char = "↲",
			cr_char = "←",
			enabled = true,
		})
	end,
}
