return {
	-- DEV - testing out local changes
	-- "gitlab-org/editor-extensions/gitlab.vim.git",
	dir = "~/gitlab/dmacario/gitlab.vim",
	dev = true,
	event = { "BufReadPre", "BufNewFile" },
	ft = { "go", "javascript", "python", "ruby", "c", "cpp", "sh" },
	cond = function()
		-- Only activate if token is present in environment variable.
		-- Remove this line to use the interactive workflow.
		return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ""
	end,
	config = function()
		require("gitlab").setup({
			statusline = {
				-- Hook into the built-in statusline to indicate the status
				-- of the GitLab Duo Code Suggestions integration
				enabled = false,
				-- ^ disabled - TODO: create custom lualine component
			},
			resource_editing = {
				-- If enabled, allows to edit GitLab resources (issues/MRs) from Neovim
				enabled = false,
			},
			minimal_message_level = vim.lsp.log_levels.DEBUG,
			code_suggestions = {
				auto_filetypes = {
					"c",
					"cpp",
					"go",
					"python",
					"sh",
				},
				ghost_text = {
					enabled = true,
					toggle_enabled = "<C-a>", -- overridden becaus of harpoon
					accept_suggestion = "<C-l>",
					clear_suggestions = "<C-k>",
					stream = true,
				},
			},
		})
		vim.keymap.set("n", "<C-g>", "<Plug>(GitLabToggleCodeSuggestions)", { silent = true })
		vim.keymap.set("i", "<C-g>", "<ESC><Plug>(GitLabToggleCodeSuggestions)A", { silent = true })
	end,
}
