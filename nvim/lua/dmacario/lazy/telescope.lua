return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						-- Custom find_files targets (sometimes I need to find ignored files, e.g., notes)
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
						no_ignore = true,
					},
					live_grep = {
						additional_args = { "--hidden", "--glob", "!**/.git/*" },
						no_ignore = true,
					},
					grep_string = {
						find_command = { "--hidden", "--glob", "!**/.git/*" },
						no_ignore = true,
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set(
				"n",
				"<leader>fg",
				builtin.git_files,
				{ desc = "Telescope find version-controlled (git) files" }
			)
			vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep (find text in files)" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope find buffers" })
			vim.keymap.set("n", "<leader>fS", builtin.grep_string, { desc = "Telescope find string (under cursor)" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
