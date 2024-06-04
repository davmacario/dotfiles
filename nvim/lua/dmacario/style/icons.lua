ICONS = {}

ICONS.kind_icons = {
	Class = " ",
	Method = " ",
	Function = "ƒ ",
	Text = " ",
	Constructor = " ",
	Field = "󰄶 ",
	File = " ",
	Variable = " ",
	Module = "󰏗 ",
	Keyword = "󰌋 ",
	Interface = "󰜰 ",
	Property = "󰜢 ",
	Unit = " ",
	Value = "󰎠 ",
	Snippet = " ",
	Enum = " ",
	EnumMember = " ",
	Color = "󰏘 ",
	Reference = " ",
	Folder = "󰉋 ",
	Constant = " ",
	Struct = " ",
	Event = " ",
	Operator = " ",
	TypeParameter = "󰅲 ",
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
