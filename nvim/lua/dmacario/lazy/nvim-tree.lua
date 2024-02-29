local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<C-w>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end


return{
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    vim.keymap.set('n', '<leader>o', vim.cmd.NvimTreeToggle)
    -- Disable netrw:
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      git = {
        enable = true,
      },
      sort = {
        sorter = "case_sensitive",
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
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
            git = {
              unstaged = "",
              staged = "",
              unmerged = "",
              renamed = "󰑕",
              deleted = "󰆴",
              untracked = "",
              ignored = "",
            },
          },
        },
      },
    })
    require("nvim-web-devicons").setup({
      strict = true,
      -- Filetype icon override (missing icons)
      override_by_extension = {
        toml = {
          icon = "",
          color = "#bdb76b",
          name = "Toml",
        }
      }
    })
    end,
  }

