return{
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap-python"
    },
    config = function()
        require("venv-selector").setup()

        vim.keymap.set("n", "<leader>vs", ":VenvSelect<CR>")
        vim.keymap.set("n", "<leader>vc", ":VenvSelectCached<CR>")
    end
}
