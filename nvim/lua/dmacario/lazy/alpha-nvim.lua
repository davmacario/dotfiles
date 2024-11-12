local utils = require("dmacario.utils")
local icons = require("dmacario.style.icons")

return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		-- dashboard.section.header.val = logo
		dashboard.section.header.val = utils.cowsay()

		local ia = icons.alpha
		dashboard.section.buttons.val = {
			dashboard.button("i", ia.new_file .. "    new file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("o", ia.old_files .. "    old files", ":Telescope oldfiles<CR>"),
			dashboard.button("f", ia.find_file .. "    find file", ":Telescope find_files<CR>"),
			dashboard.button(
				"s",
				ia.find_text .. "    find text",
				":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
			),
			dashboard.button("g", ia.git_files .. "    find git files", ":Telescope git_files<CR>"),
			dashboard.button( -- assumes it is used in conjunction with <leader>se
				"r",
				ia.resume_session .. "    resume session",
				function()
					utils.smart_session_restore()
				end
			),
			dashboard.button("l", ia.lazy .. "    lazy", ":Lazy<CR>"),
			dashboard.button("m", ia.mason .. "    mason", ":Mason<CR>"),
			dashboard.button("q", ia.quit .. "    quit", ":qa<CR>"),
		}
		dashboard.section.footer.opts.hl = "Type"
		-- dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"
		dashboard.opts.layout[1].val = 6
		return dashboard
	end,
	config = function(_, dashboard)
		require("alpha").setup(dashboard.opts)
		vim.api.nvim_create_autocmd("User", {
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100) / 100
				dashboard.section.footer.val = "󱐌 Lazy-loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
