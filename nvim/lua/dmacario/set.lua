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
vim.opt.foldlevel = 99
-- Encoding
vim.opt.encoding = "UTF-8"
vim.opt.updatetime = 50
-- vim.opt.backspace=indent,eol,start
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.conceallevel = 0

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.undodir = vim.env.HOME .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

-- Add column at 80 chars
vim.opt.colorcolumn = "80"

-- TODO: review once Telescope border is fixed
-- vim.o.winborder = "rounded"

-- Settings for lualine
vim.opt.showtabline = 2
vim.opt.showmode = false

-- Line wrap
vim.opt.wrap = true

local utils = require("dmacario.utils")
-- Statuscolumn settings
local separator_l = " "
local separator_r = " "
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
vim.opt.formatoptions:append("ro") -- jcroql (no t - autowrap text)

-- Handle copy-paste in WSL :/
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
