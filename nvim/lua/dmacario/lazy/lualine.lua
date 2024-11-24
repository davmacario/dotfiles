local icons = require("dmacario.style.icons")
local utils = require("dmacario.utils")

-- Function to prevent the winbar to disappear by ensuring there is always
-- something to display
-- A bit hacky, but it works
local function breadcrumbs()
	local navic = require("nvim-navic")
	local prefix_data = { -- Dummy element
		kind = 1,
		type = "file",
		icon = icons.navic.prefix,
		name = "",
		scope = "",
	}
	local separator = "%#NavicSeparator#" .. icons.navic.separator .. "%*"
	if navic.is_available() then
		-- Return position in the file (or some placeholder)
		local data = navic.get_data()
		table.insert(data, 1, prefix_data)
		local location = navic.format_data(data)
		-- local location = navic.get_location()
		if location ~= "" then
			return location
		end
	end
	return navic.format_data({ prefix_data })
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"tpope/vim-fugitive",
	},
	lazy = false,
	priority = 1000,
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "custom_gruvbox",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					"NvimTree",
					"dapui_stacks",
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dap-repl",
					"fugitiveblame",
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 300,
					tabline = 300,
					winbar = 300,
				},
			},
			sections = {
				lualine_a = { { "mode", icon = icons.vim_logo } },
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = icons.git_icons,
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					{
						"diagnostics",
						symbols = icons.diagnostics,
					},
				},
				lualine_c = {
					{ "filename", path = 1 },
					"searchcount",
				},
				lualine_x = {
					utils.get_ollama_status_icon,
					"encoding",
					{ "fileformat", symbols = { unix = icons.os_icon } },
				},
				lualine_y = { "filetype", "progress" },
				lualine_z = { { "location", icon = icons.location_logo } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 2 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = { lualine_c = { utils.breadcrumbs } },
			inactive_winbar = { lualine_c = { utils.breadcrumbs } },
			extensions = { "fugitive", "trouble" },
		})
	end,
}
