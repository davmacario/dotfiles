local icons = require("dmacario.style.icons")

return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	config = function()
		require("barbar").setup({
			-- Enable/disable animations
			animation = true,

			-- Enable/disable current/total tabpages indicator (top right corner)
			tabpages = true,

			-- Enables/disable clickable tabs
			--  - left-click: go to buffer
			--  - middle-click: delete buffer
			clickable = true,

			-- A buffer to this direction will be focused (if it exists) when closing the current buffer.
			-- Valid options are 'left' (the default), 'previous', and 'right'
			focus_on_close = "left",

			-- Disable highlighting alternate buffers
			highlight_alternate = false,

			-- Disable highlighting file icons in inactive buffers
			highlight_inactive_file_icons = false,

			-- Enable highlighting visible buffers
			highlight_visible = true,

			icons = {
				-- Configure the base icons on the bufferline.
				-- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
				buffer_index = false,
				buffer_number = false,
				button = icons.bufferline.button,
				-- Enables / disables diagnostic symbols
				diagnostics = {
					[vim.diagnostic.severity.ERROR] = { enabled = false },
					[vim.diagnostic.severity.WARN] = { enabled = false },
					[vim.diagnostic.severity.INFO] = { enabled = false },
					[vim.diagnostic.severity.HINT] = { enabled = false },
				},
				gitsigns = {
					added = { enabled = false },
					changed = { enabled = false },
					deleted = { enabled = false },
				},
				filetype = {
					-- Sets the icon's highlight group.
					-- If false, will use nvim-web-devicons colors
					custom_colors = false,

					-- Requires `nvim-web-devicons` if `true`
					enabled = true,
				},
				separator = { left = "▎", right = "" },

				-- If true, add an additional separator at the end of the buffer list
				separator_at_end = true,

				-- Configure the icons on the bufferline when modified or pinned.
				-- Supports all the base icon options.
				modified = { button = icons.bufferline.modified },
				pinned = { button = icons.bufferline.pinned, filename = true },

				-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
				preset = "default",

				-- Configure the icons on the bufferline based on the visibility of a buffer.
				-- Supports all the base icon options, plus `modified` and `pinned`.
				alternate = { filetype = { enabled = false } },
				current = { buffer_index = false },
				inactive = { button = icons.bufferline.button },
				visible = { modified = { buffer_number = false } },
			},

			-- If true, new buffers will be inserted at the start/end of the list.
			-- Default is to insert after current buffer.
			insert_at_end = true,
			insert_at_start = false,

			-- Sets the maximum padding width with which to surround each tab
			maximum_padding = 1,

			-- Sets the minimum padding width with which to surround each tab
			minimum_padding = 1,

			-- Sets the maximum buffer name length.
			maximum_length = 30,

			-- Sets the minimum buffer name length.
			minimum_length = 0,

			-- If set, the letters for each buffer in buffer-pick mode will be
			-- assigned based on their name. Otherwise or in case all letters are
			-- already assigned, the behavior is to assign letters in order of
			-- usability (see order below)
			semantic_letters = true,

			-- Set the filetypes which barbar will offset itself for
			sidebar_filetypes = {
				-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
				NvimTree = true,
				undotree = true,
        ["gitsigns-blame"] = true
			},

			-- New buffer letters are assigned in this order. This order is
			-- optimal for the qwerty keyboard layout but might need adjustment
			-- for other layouts.
			letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

			-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
			-- where X is the buffer number. But only a static string is accepted here.
			no_name_title = nil,

			-- sorting options
			sort = {
				-- tells barbar to ignore case differences while sorting buffers
				ignore_case = true,
			},
		})
	end,
}
