return{
    'preservim/nerdtree',
    config = function()
        vim.keymap.set('n', '<leader>o', vim.cmd.NERDTreeToggle)
        vim.g.NerdTreeShowHidden = true
    end
}
