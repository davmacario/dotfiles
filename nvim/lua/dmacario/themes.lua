local cmd = vim.cmd
local set_hl = vim.api.nvim_set_hl
local sign_define = vim.fn.sign_define


-- Set colors
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Highlight groups override
-- Underlines for diagnostics (NOT WORKING in iTerm2)
cmd("hi LspDiagnosticsUnderlineError guisp=red gui=bold,italic,underline")
cmd("hi LspDiagnosticsUnderlineWarning guisp=orange gui=bold,italic,underline")
cmd("hi LspDiagnosticsUnderlineInformation guisp=yellow gui=bold,italic,underline")
cmd("hi LspDiagnosticsUnderlineHint guisp=green gui=bold,italic,underline")

-- Diagnostics colors and signs
local signs = { Error = "", Warn = "", Info = "", Hint = "󰌶" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  local texthl = "Diagnostic" .. type
  sign_define(hl, { text = icon, texthl = texthl, numhl = texthl })
end
vim.diagnostic.config({
  underline = true,
})

-- Nvim-tree overrides
vim.cmd("highlight link NvimTreeGitDirtyIcon GruvboxYellow")
vim.cmd("highlight link NvimTreeGitStagedIcon GruvboxGreen")
