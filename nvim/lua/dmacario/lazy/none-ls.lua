return {
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"prettier",
					"black",
					"isort",
					"flake8",
					"markdownlint",
					"clang-format",
					"shellcheck",
					"bibtex-tidy",
					"latexindent",
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = { -- Add here functionalities (formatting, diagnostics, ...)
          -- Formatting sources
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.markdownlint,
					null_ls.builtins.formatting.clang_format.with({
						extra_args = {
							"--style={BasedOnStyle: Chromium, IndentWidth: 4}",
						},
					}),

          -- Diagnostics sources
					null_ls.builtins.diagnostics.markdownlint,
				},
			})
			-- Keymaps
			vim.keymap.set("n", "<leader>ft", vim.lsp.buf.format, { desc = "Format current buffer" })
		end,
	},
}
