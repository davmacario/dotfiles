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


-- Return true if inside a git repository
function M.is_git_repo()
	local _ =  vim.fn.system("git rev-parse --is-inside-work-tree")
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
      return "Session_" .. branch_name_fixed ..".vim"
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
		result = vim.fn.system(string.format("fortune | cowsay -W %s", max_width))
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

-- Get max line length from editorconfig (default: 80 chars)
function M.get_editorconfig_max_line_length()
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

-- For python files, grab the maximum line length from teh active flake8 config
-- and use it to set the value of colorcolumn
function M.get_flake8_max_line_length()
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
		return "gitlab-ci.yml" -- Return `gitlab-ci.yml` as the extension
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


return M