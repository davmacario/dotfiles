return{
    'dense-analysis/ale',
    config = function()
        -- vim.g.ale_linters = {
        --     python = {'Black', 'flake8'},
        --     markdown = {'prettier', 'markdownlint'},
        --     lua = {'lua-format'},
        -- }

        vim.api.nvim_exec([[
            let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['black', 'isort'],
            \   'markdown': ['prettier'],
            \   'lua': ['lua-format'],
            \   'json': ['prettier'],
            \   'c': ['clangtidy'],
            \   'c++': ['clangtidy'],
            \   'cmake': ['cmakeformat'],
            \}
        ]], false)

        -- -- Since the '*' key is not supported in Lua, switch to vimscript...
        -- vim.g.ale_fixers = {
        --     python = {
        --         'black',
        --         'isort'
        --     },
        --     markdown = {
        --         'prettier',
        --     }
        -- }

        vim.g.ale_sign_error = '✘'
        vim.g.ale_sign_warning = '⚠'
        vim.g.ale_linters_explicit = 1
        vim.g.ale_lint_on_text_changed = 'never'
        vim.g.ale_lint_on_enter = 0
        vim.g.ale_lint_on_save = 1
        vim.g.ale_fix_on_save = 1
        vim.g.ale_completion_enabled = 0

        vim.g.ale_python_flake8_options = '--max-line-length=88'
        vim.g.ale_python_black_options = '--line-length=88'
    end
}
