-- This script sets up colors and theme

function ColorMyPencils(color)
  -- Set colorscheme (default: gruvbox) and transparent background
  local cmd = vim.cmd
  local sign_define = vim.fn.sign_define
  local set_hl = vim.api.nvim_set_hl

  color = color or "gruvbox"
  vim.cmd.colorscheme(color)

  set_hl(0, "Normal", { bg = "none" })
  set_hl(0, "NormalFloat", { bg = "none" })

  -- Set colors
  vim.o.background = "dark" -- or "light" for light mode

  -- Highlight groups override
  -- Underlines for diagnostics (NOT WORKING in iTerm2)
  set_hl(0, "LspDiagnosticsUnderlineError", {fg = "red", bold = true, italic = true, underline = true})
  set_hl(0, "LspDiagnosticsUnderlineWarning", {fg = "orange", bold = true, italic = true, underline = true})
  set_hl(0, "LspDiagnosticsUnderlineInformation", {fg = "yellow", bold = true, italic = true, underline = true})
  set_hl(0, "LspDiagnosticsUnderlineHint", {fg = "green", bold = true, italic = true, underline = true})

  -- Diagnostics configuration
  local signs = require("dmacario.style.icons").diagnostics
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = signs.error,
        [vim.diagnostic.severity.WARN] = signs.warn,
        [vim.diagnostic.severity.INFO] = signs.info,
        [vim.diagnostic.severity.HINT] = signs.hint,
      },
    },
    underline = true,
    virtual_text = {
      prefix = "●", -- Could be '■', '▎', 'x'
    },
    float = true,
  })
end

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    name = "gruvbox",
    palette_overrides = {
      bright_green = "#990000",
    },
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        transparent_mode = true,
        underline = true,
        undercurl = true,
        overrides = {},
      })
      ColorMyPencils()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
