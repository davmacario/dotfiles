print("Config sourced!")

require("dmacario.remap")
require("dmacario.set")
require("dmacario.lazy_init")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.opt.termguicolors = true

require('nvim-web-devicons').get_icons()
require("nvim-web-devicons").get_icon_by_filetype(filetype, opts)
