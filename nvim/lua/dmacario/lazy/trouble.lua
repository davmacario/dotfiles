return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		fold_open = "⏷",
		fold_closed = "⏵",
		signs = require("dmacario.style.icons").diagnostics,
		use_diagnostic_signs = false,
	},
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)"
    },
    {
      "<leader>xd",
      "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)"
    },
    {
      "<leader>xl",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>gR",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
