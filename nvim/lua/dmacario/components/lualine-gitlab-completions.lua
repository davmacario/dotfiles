-- GitLab Code Completion status component for Lualine
local gitlab_globals = require("gitlab.globals")
local icons = require("dmacario.style.icons").gitlab

-- Create hl groups for gitlab orange and inactive grey
local function setup_highlights()
	vim.api.nvim_set_hl(0, "GitLabOrange", { fg = icons.color_active, bg = "#3c3836" })
	vim.api.nvim_set_hl(0, "InactiveGrey", { fg = icons.color_inactive, bg = "#3c3836" })
end

local M = require("lualine.component"):extend()

M.init = false
M.gitlab_element_icons = vim.deepcopy(gitlab_globals, true)

function M:init(options)
	M.super.init(self, options)

	setup_highlights()
	M.gitlab_element_icons = vim.tbl_extend("keep", M.gitlab_element_icons, {
		GCS_UNKNOWN_ICON = "%#InactiveGrey#" .. icons.logo_empty,
		GCS_AVAILABLE_AND_ENABLED_ICON = "%#GitLabOrange#" .. icons.logo_full,
		GCS_AVAILABLE_BUT_DISABLED_ICON = "%#GitLabOrange#" .. icons.logo_empty,
		GCS_CHECKING_ICON = "%#InactiveGrey#" .. icons.logo_full,
		GCS_UNAVAILABLE_ICON = icons.check_ko .. "%#InactiveGrey#" .. icons.logo_empty,
		GCS_INSTALLED_ICON = icons.check_ok .. "%#GitLabOrange#" .. icons.logo_empty,
		GCS_UPDATED_ICON = icons.check_ok .. "%#GitLabOrange#" .. icons.logo_empty,
	})
	M.init = true
end

local function state_label_for(state)
	if M.init then
		if state == gitlab_globals.GCS_AVAILABLE_AND_ENABLED then
			return M.gitlab_element_icons.GCS_AVAILABLE_AND_ENABLED_ICON
		elseif state == gitlab_globals.GCS_AVAILABLE_BUT_DISABLED then
			return M.gitlab_element_icons.GCS_AVAILABLE_BUT_DISABLED_ICON
		elseif state == gitlab_globals.GCS_CHECKING then
			return M.gitlab_element_icons.GCS_CHECKING_ICON
		elseif state == gitlab_globals.GCS_INSTALLED then
			return M.gitlab_element_icons.GCS_INSTALLED_ICON
		elseif state == gitlab_globals.GCS_UNAVAILABLE then
			return M.gitlab_element_icons.GCS_UNAVAILABLE_ICON
		elseif state == gitlab_globals.GCS_UPDATED then
			return M.gitlab_element_icons.GCS_UPDATED_ICON
		end
	end
	return M.gitlab_element_icons.GCS_UNKNOWN_ICON
end

function M:update_status()
	local new_status = require("gitlab.statusline").state
	return state_label_for(new_status)
end

return M
