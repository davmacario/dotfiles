return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
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
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/my_snippets" })
		end,
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"L3MON4D3/LuaSnip",
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "enter",
				["<cr>"] = { "accept", "fallback" },
				["<c-l>"] = { "show", "show_documentation", "hide_documentation" },
				["<c-e>"] = { "hide", "fallback" },
				["<tab>"] = { "select_next", "fallback" },
				["<s-tab>"] = { "select_prev", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
				["<C-space>"] = { "fallback" }, -- Used for other things
			},

			appearance = {
				nerd_font_variant = "normal",
			},

			completion = {
				keyword = {
					range = "prefix",
				},
				accept = { auto_brackets = { enabled = false } },
				list = { selection = { preselect = false, auto_insert = true } },
				menu = {
					border = "none",
					draw = {
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx) -- Customize icon
									local custom_icons = require("dmacario.style.icons").kind_icons
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = custom_icons[ctx.kind]
									end

									return icon .. ctx.icon_gap
								end,
							},
						},
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					},
				},
				documentation = {
					-- See keymaps: pressing <C-l> on current selection triggers docs
					auto_show = false,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = false },
			},
			signature = { enabled = true, window = { border = "rounded" } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					buffer = {
						opts = {
							-- or (recommended) filter to only "normal" buffers
							get_bufnrs = function()
								return vim.tbl_filter(function(bufnr)
									return vim.bo[bufnr].buftype == ""
								end, vim.api.nvim_list_bufs())
							end,
						},
					},
				},
			},

			snippets = {
				preset = "luasnip",
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
