-- User-defined commands
local usercmd = vim.api.nvim_create_user_command
local utils = require("dmacario.utils")

-- Tips (custom file)
usercmd("Tips", utils.open_tips, { desc = "Open user tips in read-only buffer" })

-- Useful for plugin development
usercmd("Test", function(opts)
  local args = vim.split(opts.args, " ")
  package.loaded[args[1]] = nil
  require(args[1])[args[2]]()
end, { desc = "Reload the plugin and call the function passed as args", nargs = "+" })
