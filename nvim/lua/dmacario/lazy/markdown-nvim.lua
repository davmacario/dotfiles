return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown", "codecompanion" },
	opts = {
		render_modes = { "n", "c", "t" },
		-- Mimic UX
		preset = "obsidian",
		-- Do not render markdown nested within markdown (code block)
		nested = false,
		-- Conceal settings
		anti_conceal = {
			enabled = true,
			ignore = {
				code_background = true,
				indent = true,
				sign = true,
				virtual_lines = true,
			},
		},
		completions = {
			lsp = { enabled = true },
		},
		file_types = { "markdown", "codecompanion" },
		heading = {
			-- Turn on / off heading icon & background rendering
			enabled = true,
			-- Determines how icons fill the available space:
			--  inline:  underlying '#'s are concealed resulting in a left aligned icon
			--  overlay: result is left padded with spaces to hide any additional '#'
			position = "overlay",
			-- Replaces '#+' of 'atx_h._marker'
			-- The number of '#' in the heading determines the 'level'
			-- The 'level' is used to index into the array using a cycle
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			-- Added to the sign column if enabled
			-- The 'level' is used to index into the array using a cycle
			signs = { "󰫎 " },
			-- Width of the heading background:
			--  block: width of the heading text
			--  full:  full width of the window
			-- Can also be an array of the above values in which case the 'level' is used
			-- to index into the array using a clamp
			width = "full",
			-- Amount of padding to add to the left of headings
			left_pad = 0,
			-- Amount of padding to add to the right of headings when width is 'block'
			right_pad = 0,
			-- Minimum width to use for headings when width is 'block'
			min_width = 0,
			-- Determins if a border is added above and below headings
			border = false,
			-- Highlight the start of the border using the foreground highlight
			border_prefix = false,
			-- Used above heading for border
			above = "▄",
			-- Used below heading for border
			below = "▀",
			-- The 'level' is used to index into the array using a clamp
			-- Highlight for the heading icon and extends through the entire line
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
			-- The 'level' is used to index into the array using a clamp
			-- Highlight for the heading and sign icons
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH2",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH5",
				"RenderMarkdownH6",
			},
		},
		code = {
			-- Turn on / off code block & inline code rendering
			enabled = true,
			-- Turn on / off any sign column related rendering
			sign = true,
			-- Determines how code blocks & inline code are rendered:
			--  none:     disables all rendering
			--  normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
			--  language: adds language icon to sign column if enabled and icon + name above code blocks
			--  full:     normal + language
			style = "full",
			-- Determines where language icon is rendered:
			--  right: right side of code block
			--  left:  left side of code block
			position = "left",
			-- Amount of padding to add around the language
			language_pad = 0,
			-- An array of language names for which background highlighting will be disabled
			-- Likely because that language has background highlights itself
			disable_background = { "diff" },
			-- Width of the code block background:
			--  block: width of the code block
			--  full:  full width of the window
			width = "full",
			-- Amount of padding to add to the left of code blocks
			left_pad = 0,
			-- Amount of padding to add to the right of code blocks when width is 'block'
			right_pad = 0,
			-- Minimum width to use for code blocks when width is 'block'
			min_width = 0,
			-- Determins how the top / bottom of code block are rendered:
			--  thick: use the same highlight as the code body
			--  thin:  when lines are empty overlay the above & below icons
			border = "thin",
			-- Used above code blocks for thin border
			above = "▄",
			-- Used below code blocks for thin border
			below = "▀",
			-- Highlight for code blocks
			highlight = "RenderMarkdownCode",
			-- Highlight for inline code
			highlight_inline = "RenderMarkdownCodeInline",
		},
		dash = {
			-- Turn on / off thematic break rendering
			enabled = true,
			-- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
			-- The icon gets repeated across the window's width
			icon = "─",
			-- Width of the generated line:
			--  <integer>: a hard coded width value
			--  full:      full width of the window
			width = "full",
			-- Highlight for the whole line generated from the icon
			highlight = "RenderMarkdownDash",
		},
		bullet = {
			-- Turn on / off list bullet rendering
			enabled = true,
			-- Replaces '-'|'+'|'*' of 'list_item'
			-- How deeply nested the list is determines the 'level'
			-- The 'level' is used to index into the array using a cycle
			-- If the item is a 'checkbox' a conceal is used to hide the bullet instead
			icons = { "●", "○", "◆", "◇" },
			-- Padding to add to the left of bullet point
			left_pad = 0,
			-- Padding to add to the right of bullet point
			right_pad = 0,
			-- Highlight for the bullet icon
			highlight = "RenderMarkdownBullet",
		},
		-- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
		-- There are two special states for unchecked & checked defined in the markdown grammar
		checkbox = {
			-- Turn on / off checkbox state rendering
			enabled = true,
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
				in_progress = {
					raw = "[>]",
					rendered = "󰦕 ",
					highlight = "RenderMarkdownTodo",
					scope_highlight = nil,
				},
				blocked = { raw = "[!]", rendered = " ", highlight = "RenderMarkdownWarn", scope_highlight = nil },
				cancelled = {
					raw = "[~]",
					rendered = "󰜺 ",
					highlight = "RenderMarkdownError",
					scope_highlight = nil,
				},
			},
		},
		html = {
			enabled = true,
			comment = {
				conceal = false,
			},
		},
		latex = {
			enabled = false,
		},
	},
}
