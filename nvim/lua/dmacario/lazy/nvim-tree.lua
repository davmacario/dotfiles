local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "<C-w>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

-- Get the file extension (custom)
local function get_special_ext(name)
  if name:find(".*%.gitlab%-ci.*%.yml") then -- Match <>.gitlab-ci<>.yml
    return "gitlab-ci.yml"                  -- Return `gitlab-ci.yml` as the extension
  end
  return nil
end

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.keymap.set("n", "<leader>o", vim.cmd.NvimTreeToggle)
    -- Disable netrw:
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local icons = require("dmacario.style.icons")

    local devicons = require("nvim-web-devicons")
    local get_icon = devicons.get_icon
    devicons.get_icon = function(name, ext, opts)
      return get_icon(name, get_special_ext(name) or ext, opts)
    end
    local get_icon_colors = devicons.get_icon_colors
    devicons.get_icon_colors = function(name, ext, opts)
      return get_icon_colors(name, get_special_ext(name) or ext, opts)
    end
    devicons.setup({
      strict = true,
      override_by_filename = {
        [".flake8"] = ICONS.filetypes.python,
      },
      override_by_extension = {
        ["gitlab-ci.yml"] = ICONS.filetypes.gitlab,
        ["gitconfig"] = ICONS.filetypes.gitconfig,
      },
    })
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
        icons = icons.tree_icons,
      },
    })
    -- Nvim-tree color overrides
    vim.cmd("highlight link NvimTreeGitDirtyIcon GruvboxYellow")
    vim.cmd("highlight link NvimTreeGitStagedIcon GruvboxGreen")
    vim.cmd("highlight link NvimTreeGitFileNewIcon GruvboxPurple")
    vim.cmd("highlight link NvimTreeGitNewIcon GruvboxPurple")
    vim.cmd("highlight link NvimTreeMergeIcon GruvboxRed")
  end,
}
