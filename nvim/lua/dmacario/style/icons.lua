ICONS = {}

ICONS.kind_icons = {
	File = " ",
	Module = "󰏗 ",
	Namespace = "󰌗 ",
	Class = " ",
	Method = " ",
	Property = "󰜢 ",
	Field = "󰄶 ",
	Constructor = " ",
	Enum = " ",
	Interface = "󰕘 ",
	Function = "ƒ ",
	Variable = " ",
	Constant = " ",
	String = "󰀬 ",
	Number = "󰎠 ",
	Boolean = "◩ ",
	Array = "󰅪 ",
	Object = "󰅩 ",
	Key = "󰌋 ",
	Null = "󰟢 ",
	Package = " ",
	EnumMember = " ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = "󰊄 ",
	Text = " ",
	Keyword = "󰌋 ",
	Unit = " ",
	Value = "󰎠 ",
	Snippet = " ",
	Color = "󰏘 ",
	Reference = " ",
	Folder = "󰉋 ",
}

ICONS.tree_icons = {
	-- show = {
	--     git = true,
	--     file = false,
	--     folder = false,
	--     folder_arrow = true,
	-- },
	glyphs = {
		folder = {
			arrow_closed = "⏵",
			arrow_open = "⏷",
		},
		git = {
			unstaged = "",
			staged = "",
			unmerged = "",
			renamed = "󰑕",
			deleted = "󰆴",
			untracked = "",
			ignored = "",
		},
	},
}

ICONS.gitsigns = {
	add = { text = "│" },
	change = { text = "│" },
	delete = { text = "_" },
	topdelete = { text = "‾" },
	changedelete = { text = "~" },
	untracked = { text = "┆" },
}

ICONS.git_icons = {
	added = " ",
	modified = " ",
	removed = " ",
}

ICONS.mason = {
	package_installed = "",
	package_pending = "",
	package_uninstalled = "",
}

ICONS.filetypes = {
	gitconfig = {
		icon = "",
		color = "#f54d27",
		name = "gitconfig",
	},
	python = {
		icon = "",
		color = "#ffbc03",
		name = "python",
	},
	python_lint = {
		icon = "",
		color = "#6d8086",
		name = "python",
	},
	gitlab = {
		icon = "",
		color = "#e24329",
		name = "gitlab",
	},
	gitkeep = {
		icon = "",
		color = "#6d8086",
		name = "gitkeep",
	},
	bat = {
		icon = "",
		color = "#00a4ef",
		cterm_color = "39",
		name = "bat",
	},
	cucumber = {
		icon = "🥒",
		name = "cucumber",
	},
	default = {
		icon = "",
		color = "#6d8086",
		cterm_color = "66",
		name = "Default",
	},
}

ICONS.diagnostics = {
	error = " ",
	warn = " ",
	hint = "󰌶 ",
	info = " ",
	other = " ",
}

if vim.loop.os_uname().sysname == "Darwin" then
	ICONS.os_icon = ""
else
	ICONS.os_icon = ""
end

ICONS.vim_logo = ""

ICONS.location_logo = ""

ICONS.ollama = {
	idle = "󱙺",
	busy = "󰚩",
	not_loaded = "",
	unreachable = "󰚌",
}

ICONS.navic = {
	separator = "  ",
	depth_limit = "󰇘",
	prefix = "",
}

ICONS.alpha = {
	new_file = "",
	old_files = "",
	find_file = "󰥨",
	find_text = "󰱼",
	git_files = "",
	resume_session = "",
	lazy = "󰒲",
	mason = "󱌣",
	quit = "󰭿",
}

ICONS.bufferline = {
	button = "",
	modified = "●",
	pinned = "",
}

ICONS.nvim_big_logo = {
	[[                                                                                                   ]],
	[[ /\\\\\_____/\\\_______________________________/\\\________/\\\___________________________         ]],
	[[ \/\\\\\\___\/\\\______________________________\/\\\_______\/\\\__________________________         ]],
	[[ _\/\\\/\\\__\/\\\______________________________\//\\\______/\\\___/\\\_____________________       ]],
	[[  _\/\\\//\\\_\/\\\_____/\\\\\\\\______/\\\\\_____\//\\\____/\\\___\///_____/\\\\\__/\\\\\__       ]],
	[[   _\/\\\\//\\\\/\\\___/\\\/////\\\___/\\\///\\\____\//\\\__/\\\_____/\\\__/\\\///\\\\\///\\\_     ]],
	[[    _\/\\\_\//\\\/\\\__/\\\\\\\\\\\___/\\\__\//\\\____\//\\\/\\\_____\/\\\_\/\\\_\//\\\__\/\\\     ]],
	[[     _\/\\\__\//\\\\\\_\//\\///////___\//\\\__/\\\______\//\\\\\______\/\\\_\/\\\__\/\\\__\/\\\_   ]],
	[[      _\/\\\___\//\\\\\__\//\\\\\\\\\\__\///\\\\\/________\//\\\_______\/\\\_\/\\\__\/\\\__\/\\\   ]],
	[[       _\///_____\/////____\//////////_____\/////___________\///________\///__\///___\///___\///__ ]],
	[[                                                                                                   ]],
}

ICONS.nvim_small_logo = {
	[[        __                _              ]],
	[[     /\ \ \___  ___/\   /(_)_ __ ___     ]],
	[[    /  \/ / _ \/ _ \ \ / | | '_ ` _ \    ]],
	[[   / /\  |  __| (_) \ V /| | | | | | |   ]],
	[[   \_\ \/ \___|\___/ \_/ |_|_| |_| |_|   ]],
	[[                                         ]],
}

ICONS.spinner = {
	symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
	length = 10,
}

return ICONS
