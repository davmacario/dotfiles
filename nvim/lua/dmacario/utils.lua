-- Collection of utility functions
local icons = require("dmacario.style.icons")
local M = {}

-- Markdown indentation -- GLOBAL FUNCTIONS

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

-- Returns the full path of the Home directory
function M.get_home()
	-- Prefer libuv (no external Vimscript call), fall back to expand()
	return vim.loop.os_homedir() or vim.fn.expand("~")
end

-- Return true if inside a git repository
function M.is_git_repo()
	local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

-- If inside a git repo, return the branch name
function M.get_dir_branch()
	if M.is_git_repo() then
		local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
		if branch ~= "" then
			return branch
		else
			return ""
		end
	else
		return ""
	end
end

-- Build the vim session name with the git branch
-- > Session_<branch_name>.vim
function M.git_branch_session_name()
	local default_name = "Session.vim"
	if not M.is_git_repo() then
		return default_name
	else
		local branch_name = M.get_dir_branch()
		if branch_name ~= "" then
			-- Replace "/", " ", "," with "-" in file name
			local branch_name_fixed = branch_name:gsub("[/ ,]", "-")
			return "Session_" .. branch_name_fixed .. ".vim"
		else
			return default_name
		end
	end
end

-- Attempt to restore session from Session*.vim file
function M.smart_session_restore()
	local default_session = "Session.vim"
	if not M.is_git_repo() then
		vim.cmd.source(default_session)
	else
		local session_name_git = M.git_branch_session_name()
		if vim.fn.filereadable(session_name_git) == 1 then
			vim.cmd.source(session_name_git)
		else
			vim.cmd.source(default_session)
		end
	end
end

-- Alpha

-- Print cowsay in startup screen (if available) - else, print big logo
function M.cowsay(max_width)
	if vim.fn.executable("cowsay") == 0 then
		return icons.nvim_big_logo
	end
	-- Used to convert the output of cowsay (from system) to a Lua table
	max_width = max_width or 39
	local result = ""
	if vim.fn.executable("fortune") == 1 then
		-- I prefer the system 'fortune', so use it if available
		result = vim.fn.system(string.format("fortune -n 300 -s | cowsay -W %s", max_width))
	else
		local fortune_result = require("alpha.fortune")({ max_width = max_width })
		local text = table.concat({ unpack(fortune_result, 2, #fortune_result) }, "\n")
		result = vim.fn.system(string.format('cowsay -W %s "%s"', max_width, text))
	end

	-- The small logo is placed above the output of cowsay
	local pos, out_table = 0, icons.nvim_small_logo
	for st, sp in
	function()
		return string.find(result, "\n", pos, true)
	end
	do
		table.insert(out_table, string.sub(result, pos, st - 1))
		pos = sp + 1
	end
	table.insert(out_table, string.sub(result, pos))
	return out_table
end

-- Line length
local root_patterns = { ".git", ".clang-format", "setup.py", ".editorconfig", ".flake8" }

-- Get max line length from editorconfig (default: 80 chars)
function M.get_editorconfig_max_line_length()
	local start_dir = vim.fn.expand("%:p:h")
	if start_dir == "" then
		start_dir = vim.fn.getcwd()
	end
	local root_project_dir = vim.fs.dirname(vim.fs.find({ ".editorconfig" }, { upward = true, path = start_dir })[1])
			or "."
	local config_files = { ".editorconfig", vim.fs.joinpath(root_project_dir, ".editorconfig") }
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

---@param filename string The filename to attempt extracting the line length from
---@return number|nil: The extracted line length (nil otherwise)
local function parse_python_line_length(filename)
	local file = io.open(filename, "r")
	if file then
		for line in file:lines() do
			local max_line_length = line:match("^%s*max%-line%-length%s*=%s*(%d+)")
					or line:match("^%s*line%-length%s*=%s*(%d+)")
			if max_line_length then
				file:close()
				return tonumber(max_line_length)
			end
		end
		file:close()
	end
	return nil
end

-- For python files, grab the maximum line length from pyproject.toml/.flake8/...
function M.get_python_max_line_length()
	local config_filenames = { "pyproject.toml", "setup.cfg", "tox.ini", ".flake8" }
	local start_dir = vim.fn.expand("%:p:h")
	if start_dir == "" then
		start_dir = vim.fn.getcwd()
	end
	local root_project_dir = vim.fs.dirname(vim.fs.find(config_filenames, { upward = true, path = start_dir })[1])
			or "."

	local out = nil
	for _, filename in ipairs(config_filenames) do
		local max_line_length = parse_python_line_length(vim.fs.joinpath(root_project_dir, filename))
		if max_line_length ~= nil then
			if out ~= nil then
				out = math.min(out, max_line_length)
			else
				out = max_line_length
			end
		end
	end

	if out ~= nil then
		return out
	end

	local editorconfig_line_length = M.get_editorconfig_max_line_length()
	if editorconfig_line_length ~= nil then
		return editorconfig_line_length
	end

	for _, filename in ipairs(config_filenames) do
		local max_line_length = parse_python_line_length(vim.fs.joinpath(vim.fn.expand("~"), filename))
		if max_line_length ~= nil then
			if out ~= nil then
				out = math.min(out, max_line_length)
			else
				out = max_line_length
			end
		end
	end

	-- Default line length if no config found (same as in ~/.flake8)
	return out or 88
end

-- Statuscol

-- Get the number of times the current line wraps
function M.get_num_wraps()
	-- Calculate the actual buffer width, accounting for splits, number columns, and other padding
	local wrapped_lines = vim.api.nvim_win_call(0, function()
		local winid = vim.api.nvim_get_current_win()

		-- get the width of the buffer
		local winwidth = vim.api.nvim_win_get_width(winid)
		local numberwidth = vim.wo.number and vim.wo.numberwidth or 0
		local signwidth = vim.fn.exists("*sign_define") == 1 and vim.fn.sign_getdefined() and 2 or 0
		local foldwidth = vim.wo.foldcolumn or 0

		-- subtract the number of empty spaces in your statuscol. I have
		-- four extra spaces in mine, to enhance readability for me
		local bufferwidth = winwidth - numberwidth - signwidth - foldwidth

		-- fetch the line and calculate its display width
		local line = vim.fn.getline(vim.v.lnum)
		local line_length = vim.fn.strdisplaywidth(line)

		return math.floor(line_length / bufferwidth)
	end)

	return wrapped_lines
end

function _G.CheckSymbolOrNumber(current)
	if vim.v.virtnum < 0 then
		return ""
	end

	if vim.v.virtnum > 0 and (vim.wo.number or vim.wo.relativenumber) then
		local num_wraps = M.get_num_wraps()
		if vim.v.virtnum == num_wraps then
			return "└"
		else
			return "│"
		end
	end
	-- vim.v.virtnum == 0, i.e., no wrap
	return current
end

-- Nvim Tree on-attach
function M.my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

-- Get special file extension (nvim web devicons)
function M.get_special_ext(name)
	if name:find(".*%.gitlab%-ci.*%.yml") then -- Match <>.gitlab-ci<>.yml
		return "gitlab-ci.yml"                  -- Return `gitlab-ci.yml` as the extension
	end
	if name:find("^Dockerfile.*") or name:find(".*.Dockerfile$") then
		return "Dockerfile"
	end
	return nil
end

-- Lualine elements

-- Check the Ollama status and return the corresponding icon
function M.get_ollama_status_icon()
	if not package.loaded["ollama"] then
		return icons.ollama.not_loaded -- .. " ~ not loaded"
	end

	if require("ollama").status ~= nil then
		local status = require("ollama").status()
		if status == "IDLE" then
			return icons.ollama.idle -- .. " ~ idle" -- nf-md-robot-outline
		elseif status == "WORKING" then
			return icons.ollama.busy -- .. " ~ busy" -- nf-md-robot
		end
	else
		return icons.ollama.unreachable -- .. " ~ unreachable"
	end
end

-- Function to prevent the winbar to disappear by ensuring there is always
-- something to display
-- A bit hacky, but it works
function M.breadcrumbs()
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

--- Function to be passed to Lualine component (fmt) to truncate component
--- @param trunc_width number|nil trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number|nil hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
function M.trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end

-- Get dir of current file
function M.get_current_file_directory()
	local source = debug.getinfo(1, "S").source
	local path = source:sub(2) -- Remove the "@" at the start of the source path
	return path:match("(.*/)")
end

-- Open file in read-only buffer
--- @param filename string
function M.open_readonly(filename)
	vim.cmd.edit(vim.fn.fnameescape(filename))
	vim.bo.readonly = true
	vim.bo.modifiable = false
end

-- Open file in floating window
--- @param filename string
--- @param opts table
function M.open_float_win(filename, opts)
	-- Default opts
	local defaults = {
		readonly = false,
		width = 0.5,
		height = 0.6,
		window = {
			relative = "editor",
			style = "minimal",
			border = "rounded",
		},
	}
	local window = {}
	local width = defaults.width
	local height = defaults.height
	local readonly = opts.readonly or defaults.readonly
	if opts ~= nil then -- extract options
		if opts.width and 1 > opts.width > 0 then
			width = opts.width
		end
		if opts.height and 1 > opts.height > 0 then
			height = opts.height
		end
		window.relative = opts.relative or defaults.window.relative
		window.style = opts.style or defaults.window.style
		window.border = opts.border or defaults.window.border
	end

	local esc_filename = vim.fn.fnameescape(filename)
	local lines = vim.fn.readfile(esc_filename)
	local newbuf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(newbuf, 0, -1, false, lines)

	vim.bo[newbuf].modifiable = not readonly
	vim.bo[newbuf].readonly = readonly
	vim.bo[newbuf].filetype = vim.filetype.match({ filename = esc_filename, buf = newbuf }) or "markdown"

	-- Ensure floating win is at least 10x80 always
	local win_width = math.max(math.floor(vim.o.columns * width), 80)
	local win_height = math.max(math.floor(vim.o.lines * height), 10)
	local win_opts = vim.tbl_extend("keep", window, {
		width = win_width,
		height = win_height,
		col = math.floor((vim.o.columns - win_width) / 2),
		row = math.floor((vim.o.lines - win_height) / 2),
	})

	local win = vim.api.nvim_open_win(newbuf, true, win_opts)
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].cursorline = false
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = newbuf, noremap = true, silent = true })
end

-- Open tips file (local)
function M.open_tips()
	M.open_float_win(M.get_current_file_directory() .. "nvim-tips.md", { readonly = true })
end

-- Get location of executable on system.
--- @param name string: the name of the executable to look for
--- @param default string|nil: the optional default return value
--- @return string: the full path to the executable
function M.get_executable(name, default)
	local res = vim.fn.exepath(name)
	if res == "" then
		return default or res
	end
	return res
end

return M
