-- General settings

-- vim.opt.guicursor = ""

-- Settings from vimrc
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
--Hybrid line numbers
vim.opt.nu = true
vim.opt.relativenumber = true
-- Autoindent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.showcmd = true
-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
-- Encoding
vim.opt.encoding = "UTF-8"
vim.opt.updatetime = 50
-- vim.opt.backspace=indent,eol,start
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.conceallevel = 0

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

-- Add column at 80 chars
vim.opt.colorcolumn = "80"

-- Settings for lualine
vim.opt.showtabline = 2
vim.opt.showmode = false

-- Line wrap
vim.opt.wrap = true

-- Statuscolumn settings
local separator_l = " "
local separator_r = " "

-- Get the number of times the current line wraps
local function get_num_wraps()
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

function CheckSymbolOrNumber(current)
	if vim.v.virtnum < 0 then
		return ""
	end

	if vim.v.virtnum > 0 and (vim.wo.number or vim.wo.relativenumber) then
		local num_wraps = get_num_wraps()
		if vim.v.virtnum == num_wraps then
			return "└"
		else
			return "│"
		end
	end
	-- vim.v.virtnum == 0, i.e., no wrap
	return current
end

vim.opt.statuscolumn = '%s%=%#CursorLineNr#%{(v:relnum == 0)?v:lua.CheckSymbolOrNumber(v:lnum)."'
	.. separator_l
	.. '":""}'
	.. '%#LineNr#%{(v:relnum != 0)?v:lua.CheckSymbolOrNumber(v:relnum)."'
	.. separator_r
	.. '":""}'

-- Do not load netrw (allows to use file tree plugin)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Spellcheck
-- vim.opt.spell = true
-- vim.opt.spelllang = "en_us"

-- FormatOptions
vim.opt.formatoptions:append("cro")

if vim.fn.has("wsl") then
	vim.opt.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end
