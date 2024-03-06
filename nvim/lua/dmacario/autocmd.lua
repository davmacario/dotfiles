local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- Disable max line length
augroup('disableLineLength', { clear = true })
autocmd('Filetype', {
  group = 'disableLineLength',
  pattern = { 'text', 'markdown', 'html', 'xhtml', 'typescript', 'json' },
  command = 'setlocal cc=0 colorcolumn=1000'
})

-- Python custom line lenght
augroup('pythonLineLength', { clear = true})
autocmd('Filetype', {
  group = 'pythonLineLength',
  pattern = { 'python', 'python3', 'py' },
  command = 'setlocal colorcolumn=88'
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua', 'json'
  },
  command = 'setlocal shiftwidth=2 tabstop=2 autoindent'
})
