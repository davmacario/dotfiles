return {
	"mcauley-penney/visual-whitespace.nvim",
	config = function()
		require("visual-whitespace").setup({
			highlight = { fg = "#a89984", bg = "#665c54" },
			space_char = "·",
			tab_char = "→",
			nl_char = "↲",
			cr_char = "←",
			enabled = true,
		})
	end,
}
