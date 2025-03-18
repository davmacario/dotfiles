return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},

		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			-- Snippets definitions (the one below is an example)
			ls.add_snippets("lua", {
				s("hello", {
					t('print("Hello '),
					i(1),
					t(' world")'),
				}),
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/my_snippets" })
			local cmp = require("cmp")
			local icons = require("dmacario.style.icons")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-e>"] = cmp.mapping.close(),
				}),
				sources = {
					{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
					{ name = "path" }, -- file paths
					{ name = "nvim_lsp", keyword_length = 2 }, -- from language server
					{ name = "nvim_lua", keyword_length = 3 }, -- complete neovim's Lua runtime API such vim.lsp.*
					{ name = "luasnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
					{ name = "buffer", keyword_length = 4 }, -- source current buffer
					{ name = "calc" }, -- source for math calculation
				},
				formatting = {
					fields = { "menu", "abbr", "kind" },
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format("%s %s", icons.kind_icons[vim_item.kind], vim_item.kind)
						-- Source
						local menu_icon = {
							nvim_lsp = "λ",
							vsnip = "⋗",
							buffer = "Ω",
							path = "",
						}
						vim_item.menu = menu_icon[entry.source.name]
						return vim_item
					end,
				},
			})
		end,
	},
}
