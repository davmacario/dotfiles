return{
  'folke/trouble.nvim',
  opts = {
    signs = {
      -- icons / text used for a diagnostic
      error = "",
      warning = "",
      hint = "󰌶",
      information = "",
      other = "",
    },
    use_diagnostic_signs = false,
  },
  vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end),
  vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end),
  vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end),
  vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end),
  vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end),
  vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end),
}
