vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"},
    { pattern = { '*.py' },
    command = "set tabstop=4  set softtabstop=4 set shiftwidth=4 set textwidth=79 set expandtab set autoindent set fileformat=unix",
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"},
    { pattern = { '*.md' },
    command = "set tabstop=2  set softtabstop=2 set shiftwidth=2 set expandtab set autoindent set fileformat=unix set spell set colorcolumn=100",
})

