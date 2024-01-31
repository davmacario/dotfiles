return{
    'lewis6991/gitsigns.nvim',
    dependencies = {
        'tpope/vim-fugitive',
        'nvim-lua/plenary.nvim',
    },
    config = function()
        vim.cmd[[ highlight GitSignsAdd    guifg=green ]]
        vim.cmd[[ highlight GitSignsChange guifg=yellow ]]
        vim.cmd[[ highlight GitSignsDelete guifg=red ]]
        vim.cmd[[ highlight GitSignsTopDelete guifg=red ]]
        vim.cmd[[ highlight GitSignsChangeDelete guifg=orange ]]
        vim.cmd[[ highlight GitSignsUntracked guifg=green ]]
        require('gitsigns').setup({
            signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
        })
    end
}
