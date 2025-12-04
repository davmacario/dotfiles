local icons = require("dmacario.style.icons")

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = {
			enabled = true,
			icon = icons.snacks_nvim.input,
			icon_hl = "SnacksInputIcon",
			icon_pos = "left",
			prompt_pos = "title",
			win = { style = "input", relative = "cursor", row = 1, col = 0 },
			expand = true,
		},
	},
}
