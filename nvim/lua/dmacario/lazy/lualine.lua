local icon
if vim.fn.has("macunix") then
    icon = ""
else
    icon = ""
end

return{
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'tpope/vim-fugitive',
  },
  lazy = false,
  priority = 1000,
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = "custom_gruvbox",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          'NvimTree',
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {'filename', 'searchcount'},
        lualine_x = {'encoding', { "fileformat", symbols = { unix = icon } }},
        lualine_y = {'filetype', 'progress'},
        lualine_z = {{ 'location', icon = ""}, 'diagnostics'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {'fugitive'}
    }
  end
}
