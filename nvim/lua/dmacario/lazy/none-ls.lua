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
					-- "black",
					"isort",
					"markdownlint",
					"clang-format",
					"bibtex-tidy",
					"latexindent",
					"trivy",
					"terraform_fmt",
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"gbprod/none-ls-shellcheck.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = { -- Add here functionalities (formatting, diagnostics, ...)
					-- Formatting sources
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier.with({
						prefer_local = "node_modules/.bin",
					}),
					-- null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.markdownlint,
					null_ls.builtins.formatting.clang_format.with({
						extra_args = {
							"--style={BasedOnStyle: Chromium, IndentWidth: 4}",
						},
					}),
					null_ls.builtins.formatting.terraform_fmt,

					-- Diagnostics sources
					null_ls.builtins.diagnostics.markdownlint.with({
						args = {
							"--stdin",
							"--disable",
							"MD013",
							"--disable",
							"MD033",
							"--disable",
							"MD059",
							"--disable",
							"MD028",
							"--",
						},
					}),
					require("none-ls-shellcheck.diagnostics"),
					-- null_ls.builtins.diagnostics.trivy,

					-- Code actions sources
					require("none-ls-shellcheck.code_actions"),
				},
			})
		end,
	},
}
