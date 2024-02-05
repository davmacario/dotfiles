return{
    'lukas-reineke/indent-blankline.nvim',
    opts = {
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
        },
    },
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
}
