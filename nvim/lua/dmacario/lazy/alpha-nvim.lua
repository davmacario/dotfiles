-- default logo (if cowsay not found)
local logo = {
	[[                                                                                                   ]],
	[[ /\\\\\_____/\\\_______________________________/\\\________/\\\___________________________         ]],
	[[ \/\\\\\\___\/\\\______________________________\/\\\_______\/\\\__________________________         ]],
	[[ _\/\\\/\\\__\/\\\______________________________\//\\\______/\\\___/\\\_____________________       ]],
	[[  _\/\\\//\\\_\/\\\_____/\\\\\\\\______/\\\\\_____\//\\\____/\\\___\///_____/\\\\\__/\\\\\__       ]],
	[[   _\/\\\\//\\\\/\\\___/\\\/////\\\___/\\\///\\\____\//\\\__/\\\_____/\\\__/\\\///\\\\\///\\\_     ]],
	[[    _\/\\\_\//\\\/\\\__/\\\\\\\\\\\___/\\\__\//\\\____\//\\\/\\\_____\/\\\_\/\\\_\//\\\__\/\\\     ]],
	[[     _\/\\\__\//\\\\\\_\//\\///////___\//\\\__/\\\______\//\\\\\______\/\\\_\/\\\__\/\\\__\/\\\_   ]],
	[[      _\/\\\___\//\\\\\__\//\\\\\\\\\\__\///\\\\\/________\//\\\_______\/\\\_\/\\\__\/\\\__\/\\\   ]],
	[[       _\///_____\/////____\//////////_____\/////___________\///________\///__\///___\///___\///__ ]],
	[[                                                                                                   ]],
}
local cowsay = function(max_width)
	if vim.fn.system("cowsay") == 0 then
		return logo
	end
	-- Used to convert the output of cowsay (from system) to a Lua table
	max_width = max_width or 39
	local result = ""
	if vim.fn.system("fortune") == 1 then
		-- I prefer the system 'fortune', so use it if available
		result = vim.fn.system(string.format('fortune | cowsay -W %s', max_width))
	else
		local fortune_result = require("alpha.fortune")({ max_width = max_width })
		local text = table.concat({ unpack(fortune_result, 2, #fortune_result) }, "\n")
		result = vim.fn.system(string.format('cowsay -W %s "%s"', max_width, text))
	end

	-- The small logo is placed above the output of cowsay
	local pos, out_table =
		0, {
			[[        __                _              ]],
			[[     /\ \ \___  ___/\   /(_)_ __ ___     ]],
			[[    /  \/ / _ \/ _ \ \ / | | '_ ` _ \    ]],
			[[   / /\  |  __| (_) \ V /| | | | | | |   ]],
			[[   \_\ \/ \___|\___/ \_/ |_|_| |_| |_|   ]],
			[[                                         ]],
		}
	for st, sp in
		function()
			return string.find(result, "\n", pos, true)
		end
	do
		table.insert(out_table, string.sub(result, pos, st - 1))
		pos = sp + 1
	end
	table.insert(out_table, string.sub(result, pos))
	return out_table
end

return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		-- dashboard.section.header.val = logo
		dashboard.section.header.val = cowsay()

		dashboard.section.buttons.val = {
			dashboard.button("i", "    new file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("o", "    old files", ":Telescope oldfiles<CR>"),
			dashboard.button("f", "󰥨    find file", ":Telescope find_files<CR>"),
			dashboard.button("s", "󰱼    find text", ":Telescope live_grep<CR>"),
			dashboard.button("g", "    find git files", ":Telescope git_files<CR>"),
			dashboard.button("l", "󰒲    lazy", ":Lazy<CR>"),
			dashboard.button("m", "󱌣    mason", ":Mason<CR>"),
			dashboard.button("q", "󰭿    quit", ":qa<CR>"),
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
