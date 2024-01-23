return{
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
        vim.keymap.set("n", "<leader>gps", ":Git push<CR>", {noremap = true})
        vim.keymap.set("n", "<leader>gpu", ":Git pull<CR>", {noremap = true})
    end
}
