-- Codecompanion Lualine component
local M = require("lualine.component"):extend()
M.processing = false
M.spinner_index = 1

function M:init(options)
	M.super.init(self, options)
	local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequest*",
		group = group,
		callback = function(request)
			if request.match == "CodeCompanionRequestStarted" then
				vim.notify("Generation started")
				self.processing = true
			elseif request.match == "CodeCompanionRequestFinished" then
				vim.notify("Generation finished")
				self.processing = false
			end
		end,
	})
end

function M:update_status()
	if self.processing then
		self.spinner_index = (self.spinner_index + 1) % ICONS.spinner.length
		return ICONS.spinner.symbols[self.spinner_index] .. ICONS.ollama.busy
	else
		return ICONS.ollama.idle
	end
end

return M
