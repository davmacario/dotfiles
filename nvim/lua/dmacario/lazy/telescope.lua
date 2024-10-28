return {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local lga_actions = require("telescope-live-grep-args.actions")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!{**/.git/*,**/__pycache__/*,*.pyc}",
					},
					mappings = {
						i = {
							["<C-h>"] = "which_key",
						},
					},
				},
				pickers = {
					find_files = {
						-- Custom find_files targets (sometimes I need to find ignored files, e.g., notes)
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"--glob",
							"!{**/.git/*,**/__pycache__/*,*.pyc,**/.venv/*}",
						},
						no_ignore = true,
					},
					live_grep = {
						no_ignore = true,
					},
					grep_string = {
						no_ignore = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
					live_grep_args = {
						auto_quoting = true,
						mappings = { -- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
								-- freeze the current list and start a fuzzy search in the frozen list
								["<C-space>"] = actions.to_fuzzy_refine,
							},
						},
					},
					file_browser = {
						theme = "ivy",
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						mappings = {
							["i"] = {
								-- your custom insert mode mappings
							},
							["n"] = {
								-- your custom normal mode mappings
							},
						},
					},
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
				},
			})
			telescope.load_extension("live_grep_args")
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
			telescope.load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set(
				"n",
				"<leader>fg",
				builtin.git_files,
				{ desc = "Telescope find version-controlled (git) files" }
			)
			-- vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep (find text in files)" })
			vim.keymap.set("n", "<leader>fs", function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end, { desc = "Telescope live grep (find text in files)" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope find buffers" })
			vim.keymap.set(
				"x",
				"<leader>fs",
				require("telescope-live-grep-args.shortcuts").grep_visual_selection,
				{ desc = "Telescope find string (under cursor)" }
			)
			vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume, {
				noremap = true,
				silent = true,
				desc = "Resume last search",
			})
			vim.keymap.set("n", "<space>fi", function()
				require("telescope").extensions.file_browser.file_browser()
			end, { desc = "Open Telescope file browser" })
		end,
	},
}
