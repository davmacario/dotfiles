require'clipboard-image'.setup {
  -- Default configuration for all filetypes
  default = {
    img_dir = "images",
    img_name = function ()  -- Nvim will prompt for the name of the new image
      vim.fn.inputsave()
      local name = vim.fn.input('Name: ')
      vim.fn.inputrestore()
      return name
    end,
    affix = "<\n  %s\n>" -- Multi lines affix
  },
  -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
  -- Missing options from `markdown` field will be replaced by options from `default` field
  markdown = {
    img_dir = {"%:p:h", "img"},  -- The specified folder relative to curr. file
    img_dir_txt = "img",
    affix = "![](%s)"
  }
}

-- Remap `PasteImg` to <leader>ip
vim.keymap.set("n", "<leader>ip", ":PasteImg<CR>", {noremap=true})
