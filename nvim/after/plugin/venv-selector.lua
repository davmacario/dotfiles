require("venv-selector").setup()

vim.keymap.set("n", "<leader>vs", ":VenvSelect<CR>")
vim.keymap.set("n", "<leader>vc", ":VenvSelectCached<CR>")
