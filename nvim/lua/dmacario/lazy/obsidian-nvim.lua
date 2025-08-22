return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		-- refer to `:h file-pattern` for more examples
		"BufReadPre "
			.. vim.env.HOME
			.. "/notes/*.md",
		"BufReadPre " .. vim.env.GHREPOS .. "/obsidian-notes/*.md",
		"BufNewFile " .. vim.env.GHREPOS .. "/notes/*.md",
		"BufNewFile " .. vim.env.GHREPOS .. "/obsidian-notes/*.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
		"saghen/blink.cmp",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				path = "~/notes",
			},
		},

		completion = {
			nvim_cmp = false,
			blink = true,
			min_chars = 3,
		},

		ui = {
			enable = false,
		},

		legacy_commands = false,
		statusline = {
			enabled = false,
		},
		footer = {
			enabled = false,
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			default_tags = { "daily-notes" },
			template = "template.md",
		},
	},
}
