return {
	"b0o/schemastore.nvim",
	config = function()
		vim.lsp.config("yamlls", {
			filetypes = { "yaml", "yml" },
			settings = {
				yaml = {
					validate = false,
					hover = true,
					completion = true,
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas(),
					customTags = {
						"!reference sequence",
						"!fn",
						"!Equals sequence",
						"!And",
						"!If",
						"!Not scalar",
						"!Or",
						"!FindInMap sequence",
						"!Base64",
						"!Cidr",
						"!Ref",
						"!Ref scalar",
						"!Sub",
						"!GetAtt",
						"!GetAZs",
						"!ImportValue",
						"!Select",
						"!Split",
						"!Join sequence",
					},
				},
			},
		})
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})
	end,
}
