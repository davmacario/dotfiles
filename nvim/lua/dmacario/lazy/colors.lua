function ColorMyPencils(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
return{
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        name = 'gruvbox',
        config = function()
            require('gruvbox').setup({
                terminal_colors = true,
                transparent_mode = true,
            })
            vim.cmd('colorscheme gruvbox')
            ColorMyPencils()
        end
    },
}
