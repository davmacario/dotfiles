local icons = require("dmacario.style.icons")

-- Define a function to check that ollama is installed and working
local function get_condition()
	return package.loaded["ollama"] and require("ollama").status ~= nil
end

-- Define a function to check the status and return the corresponding icon
local function get_status_icon()
	local status = require("ollama").status()

	if status == "IDLE" then
		return icons.ollama.idle .. " ~ idle" -- nf-md-robot-outline
	elseif status == "WORKING" then
		return icons.ollama.busy .. " ~ busy" -- nf-md-robot
	end
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
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
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
					get_status_icon,
					"encoding",
					{ "fileformat", symbols = { unix = icons.os_icon } },
				},
				lualine_y = { "filetype", "progress" },
				lualine_z = { { "location", icon = icons.location_icon } },
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
			winbar = {},
			inactive_winbar = {},
			extensions = { "fugitive", "trouble" },
		})
	end,
}
