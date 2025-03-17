local utils = require("dmacario.utils")

return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	config = function()
		local devicons = require("nvim-web-devicons")
		local get_icon = devicons.get_icon
		devicons.get_icon = function(name, ext, opts)
			return get_icon(name, utils.get_special_ext(name) or ext, opts)
		end
		local get_icon_colors = devicons.get_icon_colors
		devicons.get_icon_colors = function(name, ext, opts)
			return get_icon_colors(name, utils.get_special_ext(name) or ext, opts)
		end
		devicons.setup({
			strict = true,
			override = {
				default_icon = ICONS.filetypes.default,
			},
			override_by_filename = {
				[".flake8"] = ICONS.filetypes.python_lint,
				[".gitkeep"] = ICONS.filetypes.gitkeep,
			},
			override_by_extension = {
				["gitlab-ci.yml"] = ICONS.filetypes.gitlab,
				["gitconfig"] = ICONS.filetypes.gitconfig,
				["bat"] = ICONS.filetypes.bat,
				["feature"] = ICONS.filetypes.cucumber,
			},
		})
	end,
}
