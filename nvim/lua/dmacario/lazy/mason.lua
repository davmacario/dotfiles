local lsp_list = require("dmacario.lsp")
local icons = require("dmacario.style.icons")

return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					check_outdated_packages_on_open = true,
					border = "rounded",
					width = 0.8,
					height = 0.9,

					icons = icons.mason,
				},
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = lsp_list,
			})
		end,
	},
}
