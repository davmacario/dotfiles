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
	Interface = "󰕘",
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

ICONS.diagnostics = {
	error = "",
	warn = "",
	hint = "󰌶",
	info = "",
	other = "",
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
}

return ICONS
