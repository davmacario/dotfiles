local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

--
local function get_editorconfig_max_line_length()
	local config_files = { ".editorconfig" }
	for _, fname in ipairs(config_files) do
		local file = io.open(fname, "r")
		if file then
			for line in file:lines() do
				local max_line_length = line:match("^%s*max%_line%_length%s*=%s*(%d+)")
				if max_line_length then
					file:close()
					return tonumber(max_line_length)
				end
			end
			file:close()
		end
	end
	return 80 -- default
end

-- Colorcolumn depending on .editorconfig
augroup("setColorColumn", { clear = true })
autocmd({ "BufNewFile", "BufReadPre" }, {
	group = "setColorColumn",
	pattern = { "*" },
	callback = function()
		local max_line_length = get_editorconfig_max_line_length()
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
	command = "setlocal cc=0",
})

-- LaTeX settings
augroup("md_latex_settings", { clear = true })
autocmd("Filetype", {
	group = "md_latex_settings",
	pattern = { "latex", "tex" },
	command = "setlocal textwidth=80 conceallevel=2",
})

-- For python files, grab the maximum line length from teh active flake8 config
-- and use it to set the value of colorcolumn
local function get_flake8_max_line_length()
	local config_files = { ".flake8", "setup.cfg", "tox.ini" }
	for _, filename in ipairs(config_files) do
		local file = io.open(filename, "r")
		if file then
			for line in file:lines() do
				local max_line_length = line:match("^%s*max%-line%-length%s*=%s*(%d+)")
				if max_line_length then
					file:close()
					return tonumber(max_line_length)
				end
			end
			file:close()
		end
	end
	-- Default line length if no config found (same as in ~/.flake8)
	return 88
end

-- Python custom line lenght + comments
augroup("pythonLineLength", { clear = true })
autocmd("Filetype", {
	group = "pythonLineLength",
	pattern = { "python", "python3", "py" },
	callback = function()
		local max_line_length = get_flake8_max_line_length()
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
		"typescript",
		"yaml",
		"yml",
		"lua",
		"json",
		"markdown",
		"c",
		"cpp",
		"cc",
		".h",
		".hpp",
	},
	command = "setlocal expandtab shiftwidth=2 tabstop=2",
})

-- Treat Jenkinsfile as groovy
augroup("jenkinsGroovy", { clear = true })
autocmd({ "Filetype", "BufRead", "BufNewFile" }, {
	group = "jenkinsGroovy",
	pattern = { ".jenkins", "Jenkinsfile", "jenkinsfile", "jenkins" },
	command = "set filetype=groovy",
})

-- Set correct filetype for gitconfig (enable treesitter)
augroup("gitconfig", { clear = true })
autocmd({ "Filetype", "BufRead", "BufNewFile" }, {
	group = "gitconfig",
	pattern = { "*.gitconfig", ".gitconfig.*" },
	command = "set filetype=gitconfig",
})

-- Always remove trailing whitespaces
autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
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
	command = "set comments=b:*,b:-,b:+,n:> fo+=cro",
})

-- Function to indent a list item
function _G.markdown_indent_list_item()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*[-+*] ") then
		return vim.api.nvim_replace_termcodes("<C-t>", true, false, true) -- Use Neovim's built-in indent functionality
	end
	return vim.api.nvim_replace_termcodes("<tab>", true, false, true) -- Default Tab behavior
end

-- Function to unindent a list item
function _G.markdown_unindent_list_item_shift_tab()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*[-+*] ") then
		return vim.api.nvim_replace_termcodes("<C-d>", true, false, true) -- Use Neovim's built-in unindent functionality
	end
	return vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true) -- Default Shift-Tab behavior
end

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

-- Deactivate statuscol in alpha (dashboard)
augroup("noLineNumbers", { clear = true })
autocmd("FileType", {
	group = "noLineNumbers",
	pattern = {
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
	},
	callback = function()
		vim.opt_local.statuscolumn = ""
	end,
})

augroup("noLineNumbersNvimTree", { clear = true })
autocmd("BufEnter", {
	group = "noLineNumbersNvimTree",
	callback = function()
		if vim.bo.filetype == "NvimTree" then
			vim.opt_local.statuscolumn = ""
		end
	end,
})
