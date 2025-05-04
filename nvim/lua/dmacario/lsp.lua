-- LSP Setup

-- These will automatically be installed by Mason
local lsp_list = {
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
}

local on_attach = function(client, bufnr)
	-- Setup keymaps
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "List code actions" })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "List references of symbol under cursor" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { desc = "View workspace symbols" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename variable under cursor" })
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Get signature help" })
	vim.keymap.set("n", "<leader>ft", vim.lsp.buf.format, { desc = "Format current buffer" })

	local navic = require("nvim-navic")
	navic.attach(client, bufnr)
end

-- TODO: tidy up by creating files under lsp/ dir; may need to change dir structure
-- FIXME: I would like to update the rtp to include `nvim/lua/dmacario`, allowing
-- to look for lsp/ inside it, but it does not work...
vim.lsp.config("*", {
	root_markers = { ".git", ".hg" },
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
	on_attach = on_attach,
})
vim.lsp.config("cssls", {})
vim.lsp.config("eslint", {})
vim.lsp.config("html", {})
vim.lsp.config("jsonls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("jedi_language_server", {})
vim.lsp.config("bashls", {
	filetypes = { ".sh", "bash", ".bashrc", ".zshrc", ".conf", "sh", "zsh" },
	settings = {
		bashIde = {
			-- Disable shellcheck in bash-language-server (conflicting)
			shellcheckPath = "",
		},
	},
})
vim.lsp.config("dockerls", {})
vim.lsp.config("ltex", {
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
vim.lsp.config("texlab", {})
vim.lsp.config("marksman", {})
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			diagnostics = {
				globals = { "vim", "require" },
			},
		},
	},
})
vim.lsp.config("rust_analyzer", {
	cmd = {
		"rustup",
		"run",
		"stable",
		"rust-analyzer",
	},
})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", ".h", ".hpp" },
	root_dir = function(fname)
		return require("lspconfig.util").root_pattern(
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt"
		)(fname) or require("lspconfig.util").root_pattern(
			"Makefile",
			"configure.ac",
			"configure.in",
			"config.h.in",
			"meson.build",
			"meson_options.txt",
			"build.ninja"
		)(fname) or require("lspconfig.util").find_git_ancestor(fname)
	end,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	single_file_support = true,
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
})
vim.lsp.config("cmake", {})
vim.lsp.config("efm", {
	settings = {
		languages = {
			lua = {
				{ formatCommand = "lua-format -i", formatStdin = true },
			},
		},
	},
})
vim.lsp.config("yamlls", {
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
vim.lsp.config("terraformls", {})
vim.lsp.config("tflint", {})
vim.lsp.config("taplo", {})
vim.lsp.config("gitlab_ci_ls", {})

vim.lsp.enable(lsp_list)

-- TODO: remove the following when border is fixed in Telescope
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
	return hover({
		border = "rounded",
		-- max_width = 100,
		max_width = math.floor(vim.o.columns * 0.7),
		max_height = math.floor(vim.o.lines * 0.7),
	})
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
	return signature_help({
		border = "rounded",
		-- max_width = 100,
		max_width = math.floor(vim.o.columns * 0.7),
		max_height = math.floor(vim.o.lines * 0.7),
	})
end

-- lspconfig.gitlab_code_suggestions.setup({ capabilities = capabilities, on_attach = on_attach })

-- if configs.gitlab_lsp then
-- 	return
-- end
-- local settings = {
-- 	baseUrl = "https://gitlab.com",
-- 	token = vim.env.GITLAB_TOKEN,
-- }
-- configs.gitlab_lsp = {
-- 	default_config = {
-- 		name = "gitlab_lsp",
-- 		-- cmd = { "gitlab-lsp", "--stdio" },
-- 		-- cmd = { "node", "/Users/your_user/code/gitlab-lsp/out/node/main.js", "--stdio" },
-- 		filetypes = { "go", "javascript", "python", "ruby", "c", "cpp", "sh" },
-- 		single_file_support = true,
-- 		root_dir = function(fname)
-- 			return lspconfig.util.find_git_ancestor(fname)
-- 		end,
-- 		settings = settings,
-- 	},
-- 	docs = {
-- 		description = "GitLab Code Suggestions",
-- 	},
-- }

-- lspconfig.gitlab_lsp.setup({})

-- Diagnostics
local signs = require("dmacario.style.icons").diagnostics
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.error,
			[vim.diagnostic.severity.WARN] = signs.warn,
			[vim.diagnostic.severity.INFO] = signs.info,
			[vim.diagnostic.severity.HINT] = signs.hint,
		},
	},
	underline = true,
	virtual_text = { prefix = "●", current_line = true, spacing = 4 },
	-- virtual_lines = { current_line = true }, -- too invasive
	float = true,
})

return lsp_list
