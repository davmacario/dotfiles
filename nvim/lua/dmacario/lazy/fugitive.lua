return{
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set("n", "<leader>gst", vim.cmd.Git);
    end
}
