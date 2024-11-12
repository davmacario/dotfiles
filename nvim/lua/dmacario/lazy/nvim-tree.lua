local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.keymap.set("n", "<leader>o", vim.cmd.NvimTreeToggle)
		-- Disable netrw:
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		local icons = require("dmacario.style.icons")

		require("nvim-tree").setup({
			update_focused_file = {
				enable = true,
			},
			git = {
				enable = true,
			},
			sort = {
				sorter = "case_sensitive",
			},
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
			on_attach = my_on_attach,
			renderer = {
				icons = icons.tree_icons,
				full_name = true,
				group_empty = true,
				indent_markers = {
					enable = true,
					inline_arrows = true,
				},
			},
		})
		-- Nvim-tree color overrides
		vim.api.nvim_set_hl(0, "NvimTreeGitDirtyIcon", { link = "GruvboxYellow" })
		vim.api.nvim_set_hl(0, "NvimTreeGitStagedIcon", { link = "GruvboxGreen" })
		vim.api.nvim_set_hl(0, "NvimTreeGitFileNewIcon", { link = "GruvboxPurple" })
		vim.api.nvim_set_hl(0, "NvimTreeGitNewIcon", { link = "GruvboxPurple" })
		vim.api.nvim_set_hl(0, "NvimTreeMergeIcon", { link = "GruvboxRed" })
		vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { link = "GruvboxGray" })
		vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { link = "NvimTreeFileIcon" })
		vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { link = "NvimTreeFileIcon" })
	end,
}
