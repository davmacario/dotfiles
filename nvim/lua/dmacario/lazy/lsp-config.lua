return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					-- Whether to automatically check for new versions when opening the :Mason window.
					check_outdated_packages_on_open = true,

					-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
					border = "rounded",

					-- Width of the window. Accepts:
					-- - Integer greater than 1 for fixed width.
					-- - Float in the range of 0-1 for a percentage of screen width.
					width = 0.8,

					-- Height of the window. Accepts:
					-- - Integer greater than 1 for fixed height.
					-- - Float in the range of 0-1 for a percentage of screen height.
					height = 0.9,

					icons = {
						package_installed = "",
						package_pending = "",
						package_uninstalled = "",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"cssls",
					"eslint",
					"html",
					"jsonls",
					"pyright",
					"jedi_language_server",
					"bashls",
					"dockerls",
					"ltex",
					"texlab",
					"marksman",
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"clangd",
					"cmake",
					"efm",
					"sqlls",
					"terraformls",
					"tflint",
					"yamlls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
			},
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- local opts = {buffer = bufnr, remap = false}
			-- Keymaps
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, {})
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = 1 })
			end, { desc = "Jump to next diagnostic item" })
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = -1 })
			end, { desc = "Jump to previous diagnostic item" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {})

			-- Border of 'hover' box
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			-- Setup of the individual servers
			local lspconfig = require("lspconfig")
			local on_attach = function(client, bufnr)
				-- if client.server_capabilities.documentSymbolProvider then
				-- end
				local navic = require("nvim-navic")
				navic.attach(client, bufnr)
			end
			lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.eslint.setup({ capabilities = capabilities })
			lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.jedi_language_server.setup({ capabilities = capabilities })
			lspconfig.bashls.setup({
				capabilities = capabilities,
				filetypes = { ".sh", "bash", ".bashrc", ".zshrc", ".conf", "sh", "zsh" },
				settings = {
					bashIde = {
						-- Disable shellcheck in bash-language-server (conflicting)
						shellcheckPath = "",
					},
				},
				on_attach = on_attach,
			})
			lspconfig.dockerls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.ltex.setup({
				capabilities = capabilities,
				filetypes = { "latex", "tex" },
				settings = { -- See https://valentjn.github.io/ltex/settings.html for full list
					ltex = {
						enabled = {
							"bibtex",
							"context",
							"context.tex",
							"html",
							"latex",
							"org",
							"restructuredtext",
							"rsweave",
							-- "markdown",
						},
						language = "en-US",
						additionalRules = {
							enablePickyRules = false,
							motherTongue = "it-IT",
						},
					},
				},
			})
			lspconfig.texlab.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.marksman.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					})
				end,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "require" },
						},
					},
				},
				on_attach = on_attach,
			})

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				cmd = {
					"rustup",
					"run",
					"stable",
					"rust-analyzer",
				},
				on_attach = on_attach,
			})
			lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.cmake.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.efm.setup({
				capabilities = capabilities,
				settings = {
					rootMarkers = { "./git" },
					languages = {
						lua = {
							{ formatCommand = "lua-format -i", formatStdin = true },
						},
					},
				},
			})
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "yaml", "yml" },
				settings = {
					yaml = {
						hover = true,
						completion = true,
						customTags = {
							"!reference sequence",
						},
					},
				},
			})
			lspconfig.terraformls.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.tflint.setup({ capabilities = capabilities, on_attach = on_attach })
			lspconfig.taplo.setup({ capabilities = capabilities, on_attach = on_attach })
		end,
	},
}
