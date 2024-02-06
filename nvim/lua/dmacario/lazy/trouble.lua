return{
  'folke/trouble.nvim',
  opts = {
    signs = {
      -- icons / text used for a diagnostic
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = "",
    },
    use_diagnostic_signs = false,
  }
  -- config = function()
  --   local signs = {
  --     error = " ",
  --     warning = " ",
  --     hint = " ",
  --     information = " ",
  --     other = "",
  --   }
  --   for type, icon in pairs(signs) do
  --     local hl = "DiagnosticSign" .. type
  --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  --   end
  -- end
}
