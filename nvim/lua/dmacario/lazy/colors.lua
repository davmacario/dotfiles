function ColorMyPencils(color)
	-- Set colorscheme (default: gruvbox) and transparent background
	local set_hl = vim.api.nvim_set_hl

  color = color or "gruvbox"
  vim.cmd.colorscheme(color)

  set_hl(0, "Normal", { bg = "none" })
  set_hl(0, "NormalFloat", { bg = "none" })

  -- Set colors
  vim.o.background = "dark" -- or "light" for light mode

	-- Highlight groups override
	-- Underlines for diagnostics (NOT WORKING in iTerm2)
	set_hl(0, "LspDiagnosticsUnderlineError", { fg = "red", bold = true, italic = true, underline = true })
	set_hl(0, "LspDiagnosticsUnderlineWarning", { fg = "orange", bold = true, italic = true, underline = true })
	set_hl(0, "LspDiagnosticsUnderlineInformation", { fg = "yellow", bold = true, italic = true, underline = true })
	set_hl(0, "LspDiagnosticsUnderlineHint", { fg = "green", bold = true, italic = true, underline = true })
end

return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		name = "gruvbox",
		palette_overrides = {
			bright_green = "#990000",
		},
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
				transparent_mode = true,
				underline = true,
				undercurl = true,
				overrides = {},
			})
			ColorMyPencils()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
}
