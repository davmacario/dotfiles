return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "tpope/vim-fugitive",
  },
  config = function()
    local icons = require("dmacario.style.icons")
    require("gitsigns").setup({
      signs = icons.gitsigns,
      current_line_blame = true,
    })
    vim.keymap.set("n", "<leader>gb", function()
      vim.cmd("Gitsigns blame")
    end, { desc = "Toggle git blame window" })
  end,
}
