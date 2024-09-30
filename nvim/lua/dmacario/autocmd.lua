local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Disable max line length in some files
augroup("disableLineLength", { clear = true })
autocmd("Filetype", {
	group = "disableLineLength",
	pattern = { "html", "xhtml", "typescript", "json" },
	command = "setlocal cc=0 colorcolumn=1000",
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
  local config_files = {".flake8", "setup.cfg", "tox.ini"}
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

-- Python custom line lenght
augroup("pythonLineLength", { clear = true })
autocmd("Filetype", {
	group = "pythonLineLength",
	pattern = { "python", "python3", "py" },
  callback = function()
    local max_line_length = get_flake8_max_line_length()
    if max_line_length then
      vim.wo.colorcolumn = tostring(max_line_length)
    end
  end
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

-- Always remove trailing whitespaces
autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
	end,
})
