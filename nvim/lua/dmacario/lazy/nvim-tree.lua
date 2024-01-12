local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<leader>o', vim.cmd.NvimTreeToggle)
end


return{
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        vim.keymap.set('n', '<leader>o', vim.cmd.NERDTreeToggle)
        vim.g.NerdTreeShowHidden = true
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            filters = {
                dotfiles = true,
            },
            on_attach = my_on_attach,
            renderer = {
                icons = {
                    -- show = {
                    --     git = true,
                    --     file = false,
                    --     folder = false,
                    --     folder_arrow = true,
                    -- },
                    glyphs = {
                        folder = {
                            arrow_closed = "⏵",
                            arrow_open = "⏷",
                        },
                    },
                },
            },
        })
    end
}
