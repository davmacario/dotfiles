return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = {
				"c",
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"bash",
				"dockerfile",
				"cpp",
				"javascript",
				"python",
				"yaml",
				"markdown",
				"markdown_inline",
				"comment",
				"json",
				"jsonc",
				"rust",
				"go",
				"query",
				"hcl",
				"terraform",
				"html",
				"latex"
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			auto_install = true,

			highlight = {
				enable = true,
				disable = { "csv", "tsv" }, -- Rainbow csv
				additional_vim_regex_highlighting = { "latex", "markdown" },
			},
			playground = { enable = true },
			indent = { enable = true },
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
		})
	end,
}
