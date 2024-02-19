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
    palette_overrides = {
      bright_green = "#990000",
    },
    -- vim.api.nvim_set_hl(0, 'TroubleHint', { fg = 020}),
    -- vim.api.nvim_set_hl(0, 'TroubleTextHint', { fg = 020}),
    config = function()
      require('gruvbox').setup({
        terminal_colors = true,
        transparent_mode = true,
        underline = true,
        undercurl = true,
        overrides = {},
      })
      vim.cmd('colorscheme gruvbox')
      ColorMyPencils()
    end
  },
}
