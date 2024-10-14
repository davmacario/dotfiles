-- Get the file extension (custom)
local function get_special_ext(name)
  if name:find(".*%.gitlab%-ci.*%.yml") then -- Match <>.gitlab-ci<>.yml
    return "gitlab-ci.yml"                  -- Return `gitlab-ci.yml` as the extension
  end
  return nil
end

return {
  "nvim-tree/nvim-web-devicons",
  config = function()
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
        [".flake8"] = ICONS.filetypes.python_lint,
        [".gitkeep"] = ICONS.filetypes.gitkeep,
      },
      override_by_extension = {
        ["gitlab-ci.yml"] = ICONS.filetypes.gitlab,
        ["gitconfig"] = ICONS.filetypes.gitconfig,
      },
    })
  end,
}
