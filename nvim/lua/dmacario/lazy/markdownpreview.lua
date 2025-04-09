-- Settings and remaps for markdown preview
return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	lazy = true,
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview" },
	},
	config = function()
		vim.g.mkdp_auto_close = false
		vim.g.mkdp_open_to_the_world = false
		vim.g.mkdp_open_ip = "127.0.0.1"
		vim.g.mkdp_port = "8888"
		vim.g.mkdp_browser = os.getenv('BROWSER')
		vim.g.mkdp_echo_preview_url = true
		vim.g.mkdp_page_title = " mkdp:「${name}」"
		vim.g.mkdp_theme = "dark"
		-- Open preview in new window:
		vim.api.nvim_exec2(
			[[
        function! OpenMarkdownPreview(url)
            if has('macunix')
                execute "silent ! open -a Firefox -n --args --new-window " . a:url
                " echom ">>> new window - url: " . a:url
						elseif has('wsl')
								execute "silent ! open -a $BROWSER --new-window " . a:url
            else
                execute "silent ! firefox --new-window " . a:url
            endif
        endfunction

        let g:mkdp_browserfunc = 'OpenMarkdownPreview'
        ]],
			{ output = false }
		)
	end,
}
