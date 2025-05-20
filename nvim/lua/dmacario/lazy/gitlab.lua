return {
	-- "https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git",
	"https://gitlab.com/dmacario/gitlab.vim.git",
	-- NOTE: for testing out local changes:
	-- dir = "~/gitlab/dmacario/gitlab.vim",
	-- dev = true,
	event = { "BufReadPre", "BufNewFile" },
	ft = { "go", "javascript", "python", "ruby", "c", "cpp", "sh", "terraform" },
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
			minimal_message_level = vim.lsp.log_levels.ERROR,
			code_suggestions = {
				auto_filetypes = {
					"c",
					"cpp",
					"go",
					"python",
					"shell",
					"terraform",
				},
				ghost_text = {
					enabled = true,
					toggle_enabled = "<C-a>", -- overridden because of harpoon
					accept_suggestion = "<C-Space>",
					clear_suggestions = "<C-k>",
					stream = true,
				},
			},
			language_server = {
				-- The following get passed to LSP directly
				workspace_settings = {
					codeCompletion = {
						enableSecretRedaction = true,
					},
				},
			},
		})
		vim.keymap.set("n", "<C-g>", "<Plug>(GitLabToggleCodeSuggestions)", { silent = true })
		vim.keymap.set("i", "<C-g>", "<ESC><Plug>(GitLabToggleCodeSuggestions)A", { silent = true })
	end,
}
