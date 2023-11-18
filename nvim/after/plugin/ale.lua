vim.g.ale_linters = {
    python = {'Black', 'flake8'},
    markdown = {'writegood'},
}

vim.g.ale_fixers = {
    python = {
        'black',
        'isort'
    }
}

vim.g.ale_sign_error = '✘'
vim.g.ale_sign_warning = '⚠'
vim.g.ale_linters_explicit = 1
vim.g.ale_lint_on_text_changed = 'never'
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_save = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_completion_enabled = 0

vim.g.ale_python_flake8_options = '--max-line-length=80'


