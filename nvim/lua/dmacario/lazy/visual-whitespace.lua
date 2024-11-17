return {
	"mcauley-penney/visual-whitespace.nvim",
	commit = "f52e8302095d947407ac28cd6f41b7b0bb1d4fc8",
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
