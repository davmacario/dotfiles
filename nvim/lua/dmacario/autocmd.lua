local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Disable max line length in some files
augroup("disableLineLength", { clear = true })
autocmd("Filetype", {
	group = "disableLineLength",
	pattern = { "html", "xhtml", "typescript", "json" },
	command = "setlocal cc=0 colorcolumn=1000",
})

augroup("md_latex_settings", { clear = true })
autocmd("Filetype", {
	group = "md_latex_settings",
	pattern = { "latex", "tex" },
	command = "setlocal textwidth=80 conceallevel=2",
})

-- Python custom line lenght (from Black)
augroup("pythonLineLength", { clear = true })
autocmd("Filetype", {
	group = "pythonLineLength",
	pattern = { "python", "python3", "py" },
	command = "setlocal colorcolumn=88",
})

-- Set indentation to 2 spaces for specific filetypes
augroup("setIndent", { clear = true })
autocmd("Filetype", {
	group = "setIndent",
	pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua", "json", "markdown" },
	command = "setlocal expandtab shiftwidth=2 tabstop=2",
})

-- Treat Jenkinsfile as groovy
augroup("jenkinsGroovy", { clear = true })
autocmd("Filetype", {
	group = "jenkinsGroovy",
	pattern = { ".jenkins", "Jenkinsfile", "jenkinsfile" },
	command = "set filetype=groovy",
})
