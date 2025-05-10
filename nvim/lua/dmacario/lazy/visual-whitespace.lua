return {
	"davmacario/visual-whitespace.nvim",
	event = "ModeChanged *:[vV\22]",
	config = function()
		require("visual-whitespace").setup({
			highlight = { fg = "#a89984", bg = "#665c54" },
			list_chars = {
				space = "·",
				tab = "→",
			},
			enabled = true,
		})
	end,
}
