-- TODO:
-- - Understand how to create prompts/actions
-- - Switch models for different tasks/actions
-- - Figure out what is the deal with 'inline' mode
-- - Compare "copilot" capabilities (i.e., modifying buffer) wrt. ollama.nvim
-- - Create new dotfiles branch to test feature out (removing ollama.nvim)
-- - Add symbol to lualine (if new branch, remove ollama.nvim indicator)
-- - Codecompanion filetype: deactivate line numbers, colorcolumn
-- - Can I make the vsplit narrower? like 80 chars wide
return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = "ollama",
					},
					inline = {
						adapter = "ollama",
					},
				},
				adapters = {
					ollama = function()
						return require("codecompanion.adapters").extend("ollama", {
							env = {
								url = "http://100.91.137.78:11435",
							},
							headers = {
								["Content-Type"] = "application/json",
							},
							parameters = {
								sync = true,
							},
							schema = {
								model = {
									default = "codestral",
								},
							},
						})
					end,
				},
			})
      vim.api.nvim_set_keymap("n", "<LocalLeader>A", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<LocalLeader>A", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
		end,
	},
}
