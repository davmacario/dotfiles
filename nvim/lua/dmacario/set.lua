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
-- vim.opt.t_Co = 256    -- 256 bit colors
vim.opt.foldmethod = "indent" -- Code folding
vim.opt.foldlevel = 99        -- Default: unfolded
vim.opt.encoding = "UTF-8"
vim.opt.updatetime = 50
-- vim.opt.backspace=indent,eol,start
-- Share clipboard
-- vim.opt.clipboard = 'unnamed'
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
vim.opt.showtabline = 0
vim.opt.showmode = false

-- Line wrap
vim.opt.wrap = true

-- Do not load netrw (allows to use file tree plugin)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Spellcheck
-- vim.opt.spell = true
-- vim.opt.spelllang = "en_us"
