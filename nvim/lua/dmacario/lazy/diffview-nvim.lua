return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({
			hooks = {
				diff_buf_read = function(bufnr, ctx)
					vim.opt_local.wrap = false
				end,
			},
		})
	end,
}
