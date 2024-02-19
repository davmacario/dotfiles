-- Themes
local cmd = vim.cmd
local set_hl = vim.api.nvim_set_hl
local sign_define = vim.fn.sign_define


vim.api.nvim_exec([[
hi LspDiagnosticsUnderlineError guisp=red gui=bold,italic,underline
hi LspDiagnosticsUnderlineWarning guisp=orange gui=bold,italic,underline
hi LspDiagnosticsUnderlineInformation guisp=yellow gui=bold,italic,underline
hi LspDiagnosticsUnderlineHint guisp=green gui=bold,italic,underline
]], false)


-- Diagnostics colors and signs
set_hl(0, 'DiagnosticError', { fg = 'red', bg = 'None' })
set_hl(0, 'DiagnosticWarn', { fg = 'orange', bg = 'None' })
set_hl(0, 'DiagnosticInfo', { fg = 'teal', bg = 'None' })
set_hl(0, 'DiagnosticHint', { fg = 'white', bg = 'None' })
local signs = { Error = "", Warn = "", Info = "", Hint = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  local texthl = "Diagnostic" .. type
  sign_define(hl, { text = icon, texthl = texthl, numhl = texthl })
end
vim.diagnostic.config({
  underline = true,
})
