local os_icon
if vim.loop.os_uname().sysname == "Darwin" then
    os_icon = ""
else
    os_icon = ""
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
          'dapui_stacks',
          'dapui_watches',
          'dapui_breakpoints',
          'dapui_scopes',
          'dapui_console',
          'dap-repl',
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
        lualine_a = {{'mode', icon = ""}},
        lualine_b = {
          'branch',
          'diff',
          {
            'diagnostics',
            symbols = {
              error = "",
              warn = "",
              hint = "󰌶",
              info = "",
              other = "",
            }
          },
        },
        lualine_c = {
          {'filename', path=1},
          'searchcount'},
        lualine_x = {'encoding', { "fileformat", symbols = { unix = os_icon } }},
        lualine_y = {'filetype', 'progress'},
        lualine_z = {{ 'location', icon = ""}}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', path=2}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {'fugitive', 'trouble'}
    }
  end
}
