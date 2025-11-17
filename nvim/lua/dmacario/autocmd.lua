local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local utils = require("dmacario.utils")

-- User config
local user_config = augroup("UserConfig", { clear = true })

-- Return to last position
autocmd("BufReadPost", {
	group = user_config,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
	group = user_config,
	callback = function()
		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Colorcolumn depending on .editorconfig
augroup("setColorColumn", { clear = true })
autocmd({ "BufNewFile", "BufReadPre" }, {
	group = "setColorColumn",
	pattern = { "*" },
	callback = function()
		local max_line_length = utils.get_editorconfig_max_line_length()
		if max_line_length then
			vim.wo.colorcolumn = tostring(max_line_length)
		end
	end,
})

-- Disable max line length in some files
augroup("disableLineLength", { clear = true })
autocmd("Filetype", {
	group = "disableLineLength",
	pattern = { "html", "xhtml", "typescript", "json", "markdown" },
	command = "setlocal cc=0 textwidth=0",
})

-- LaTeX settings
augroup("md_latex_settings", { clear = true })
autocmd("Filetype", {
	group = "md_latex_settings",
	pattern = { "latex", "tex" },
	command = "setlocal textwidth=80 conceallevel=2",
})

-- Python custom line lenght + comments
augroup("pythonLineLength", { clear = true })
autocmd("Filetype", {
	group = "pythonLineLength",
	pattern = { "python", "python3", "py" },
	callback = function()
		local max_line_length = utils.get_python_max_line_length()
		if max_line_length then
			vim.wo.colorcolumn = tostring(max_line_length)
		end
		vim.opt.formatoptions:append("cro")
	end,
})

-- Set indentation to 2 spaces for specific filetypes
augroup("setIndent", { clear = true })
autocmd("Filetype", {
	group = "setIndent",
	pattern = {
		"xml",
		"html",
		"xhtml",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"yaml",
		"yml",
		"json",
		"markdown",
		"c",
		"cpp",
		"cc",
		".h",
		".hpp",
		"toml",
		".tfvars",
		".tf",
		"terraform",
		"terraform-vars",
	},
	command = "setlocal expandtab shiftwidth=2 tabstop=2",
})

augroup("luaIndent", { clear = true })
autocmd("FileType", {
	group = "luaIndent",
	pattern = {
		"lua",
	},
	command = "setlocal noexpandtab shiftwidth=2 tabstop=2",
})

augroup("golangIndent", { clear = true })
autocmd("Filetype", {
	group = "golangIndent",
	pattern = {
		"go",
	},
	command = "setlocal noexpandtab shiftwidth=4 tabstop=4",
})

--- FileType Overrides
augroup("ftOverride", { clear = true })

-- Treat Jenkinsfile as groovy
autocmd({ "Filetype", "BufRead", "BufNewFile" }, {
	group = "ftOverride",
	pattern = { "*.jenkins", "Jenkinsfile", "jenkinsfile", "jenkins" },
	command = "set filetype=groovy",
})

-- Treat .tf as terraform
autocmd({ "Filetype", "BufRead", "BufNewFile" }, {
	group = "ftOverride",
	pattern = { "*.tf", "tf" },
	command = "set filetype=terraform",
})

-- Treat .tfstate and .tfstate.backup as JSON
autocmd({ "FileType", "BufRead", "BufNewFile" }, {
	group = "ftOverride",
	pattern = { "*.tfstate", "*.tfstate.backup" },
	command = "set filetype=json",
})

-- Set correct filetype for gitconfig (enable treesitter)
autocmd({ "Filetype", "BufRead", "BufNewFile" }, {
	group = "ftOverride",
	pattern = { "*.gitconfig", ".gitconfig.*" },
	command = "set filetype=gitconfig",
})

-- Always remove trailing whitespaces on save
autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		local pos = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", pos)
	end,
})

-- Remove smartindent in some files (experiencing issues)
augroup("noSmartIndent", { clear = true })
autocmd("Filetype", {
	group = "noSmartIndent",
	pattern = {
		"python",
		"yaml",
		"markdown",
	},
	command = "set nosmartindent",
})

-- Fix formatoptions markdown
augroup("mdFormatOpts", { clear = true })
autocmd("FileType", {
	group = "mdFormatOpts",
	pattern = { "markdown" },
	command = "setlocal comments=b:*,b:-,b:+,n:> fo=jqlnro",
})

autocmd("FileType", {
	group = "mdFormatOpts",
	pattern = { "markdown" },
	callback = function()
		-- Tab for indenting list items
		vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.markdown_indent_list_item()", { expr = true, noremap = true })
		-- Shift-Tab for unindenting list items
		vim.api.nvim_set_keymap(
			"i",
			"<S-Tab>",
			"v:lua.markdown_unindent_list_item_shift_tab()",
			{ expr = true, noremap = true }
		)
		vim.keymap.set("n", "<leader>to", "o<ESC>cc- [ ] ", { desc = "Open new TODO: item below current line" })
		vim.keymap.set("n", "<leader>tO", "O<ESC>cc- [ ] ", { desc = "Open new TODO: item below current line" })
	end,
})

-- Disable markdown error highlighting (e.g., '_' used besides emphasis)
autocmd("FileType", {
	group = "mdFormatOpts",
	pattern = { "markdown" },
	command = "highlight link markdownError NONE"
})

-- Deactivate statuscol
local no_linenumbers_ftypes = {
	"help",
	"alpha",
	"dashboard",
	"neo-tree",
	"Trouble",
	"trouble",
	"lazy",
	"mason",
	"notify",
	"toggleterm",
	"lazyterm",
	"NvimTree",
	"DiffviewFiles",
}

augroup("noLineNumbers", { clear = true })
autocmd("FileType", {
	group = "noLineNumbers",
	pattern = no_linenumbers_ftypes,
	callback = function()
		vim.opt_local.statuscolumn = ""
	end,
})

augroup("noLineNumbersNvimTree", { clear = true })
autocmd("BufEnter", {
	group = "noLineNumbersNvimTree",
	callback = function()
		for _, ft in ipairs(no_linenumbers_ftypes) do
			if vim.bo.filetype == ft then
				vim.opt_local.statuscolumn = ""
			end
		end
	end,
})

augroup("specialTextObjects", { clear = true })
autocmd("FileType", {
	group = "specialTextObjects",
	pattern = { "markdown" },
	callback = function()
		-- from mini.ai docs (:h MiniAI.config)
		local spec_pair = require("mini.ai").gen_spec.pair
		vim.b.miniai_config = {
			custom_textobjects = {
				["*"] = spec_pair("*", "*", { type = "greedy" }),
				["_"] = spec_pair("_", "_", { type = "greedy" }),
				["~"] = spec_pair("~", "~", { type = "greedy" }),
			},
		}
	end,
})
