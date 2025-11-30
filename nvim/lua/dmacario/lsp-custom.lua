--- The contents of this file are used to override the default behavior of the
--- 'hover' handler to fix formatting for the Pyright LSP.
--- In its responses, there are some "weird" characters (e.g., &nbsp), which
--- can be cleaned up by fixing the `split_lines` function.
---
--- Unfortunately, NVIM 0.10 removed the capability to override handlers from
--- LSP settings, as it introduced the possibility to attach multiple LSPs to
--- a single buffer, so it needs to handle multiple requests all together
--- before being able to provide a "result" in terms of floating window with
--- hover information.
---
--- The following looks like the only way to fix formatting inside LSP
--- responses for 'hover'.
--- Most of the code is a copy-paste from:
--- - nvim/runtime/lua/vim/lsp/buf.lua (hover, client_positional_params)
--- - nvim/runtime/lua/vim/lsp/util.lua (convert_input_to_markdown_lines)
--- on Nvim v0.11.4
---
--- In the future, hopefully there will be some easier way to make such changes


local api = vim.api
local lsp = vim.lsp
local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods

local M = {}

--- Splits string at newlines, optionally removing unwanted blank lines.
---
--- @param s string Multiline string
--- @param no_blank boolean? Drop blank lines for each @param/@return (except one empty line
--- separating each). Workaround for https://github.com/LuaLS/lua-language-server/issues/2333
local function split_lines(s, no_blank)
	s = string.gsub(s, "\r\n?", "\n")

	--- NOTE: only difference is here!
	s = string.gsub(s, "&nbsp;", " ")
	s = string.gsub(s, "&gt;", ">")
	s = string.gsub(s, "&lt;", "<")
	s = string.gsub(s, "\\", "")
	---

	local lines = {}
	local in_desc = true -- Main description block, before seeing any @foo.
	for line in vim.gsplit(s, "\n", { plain = true, trimempty = true }) do
		local start_annotation = not not line:find("^ ?%@.?[pr]")
		in_desc = (not start_annotation) and in_desc or false
		if start_annotation and no_blank and not (lines[#lines] or ""):find("^%s*$") then
			table.insert(lines, "") -- Separate each @foo with a blank line.
		end
		if in_desc or not no_blank or not line:find("^%s*$") then
			table.insert(lines, line)
		end
	end
	return lines
end

--- Converts any of `MarkedString` | `MarkedString[]` | `MarkupContent` into
--- a list of lines containing valid markdown. Useful to populate the hover
--- window for `textDocument/hover`, for parsing the result of
--- `textDocument/signatureHelp`, and potentially others.
---
--- Note that if the input is of type `MarkupContent` and its kind is `plaintext`,
--- then the corresponding value is returned without further modifications.
---
---@param input lsp.MarkedString|lsp.MarkedString[]|lsp.MarkupContent
---@param contents string[]? List of strings to extend with converted lines. Defaults to {}.
---@return string[] extended with lines of converted markdown.
---@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_hover
local function convert_input_to_markdown_lines(input, contents)
	contents = contents or {}
	-- MarkedString variation 1
	if type(input) == "string" then
		vim.list_extend(contents, split_lines(input, true))
	else
		assert(type(input) == "table", "Expected a table for LSP input")
		-- MarkupContent
		if input.kind then
			local value = input.value or ""
			vim.list_extend(contents, split_lines(value, true))
			-- MarkupString variation 2
		elseif input.language then
			table.insert(contents, "```" .. input.language)
			vim.list_extend(contents, split_lines(input.value or ""))
			table.insert(contents, "```")
			-- By deduction, this must be MarkedString[]
		else
			-- Use our existing logic to handle MarkedString
			for _, marked_string in ipairs(input) do
				convert_input_to_markdown_lines(marked_string, contents)
			end
		end
	end
	if (contents[1] == "" or contents[1] == nil) and #contents == 1 then
		return {}
	end
	return contents
end

--- @param params? table
--- @return fun(client: vim.lsp.Client): lsp.TextDocumentPositionParams
local function client_positional_params(params)
	local win = api.nvim_get_current_win()
	return function(client)
		local ret = util.make_position_params(win, client.offset_encoding)
		if params then
			ret = vim.tbl_extend("force", ret, params)
		end
		return ret
	end
end

local hover_ns = vim.api.nvim_create_namespace("nvim.lsp.hover_range")

--- The overwritten hover function (see vim.lsp.buf.hover).
--- The function fixes the text in the response to remove artifacts (see
--- pyright behavior).
--- This function is overwriting the default hover, as single-lsp overrides
--- are not allowed anymore with 0.11.
--- @param config? vim.lsp.buf.hover.Opts
function M.custom_hover(config)
	config = config or {}
	config.focus_id = ms.textDocument_hover

	lsp.buf_request_all(0, ms.textDocument_hover, client_positional_params(), function(results, ctx)
		local bufnr = assert(ctx.bufnr)
		if api.nvim_get_current_buf() ~= bufnr then
			-- Ignore result since buffer changed. This happens for slow language servers.
			return
		end

		-- Filter errors from results
		local results1 = {} --- @type table<integer,lsp.Hover>

		for client_id, resp in pairs(results) do
			local err, result = resp.err, resp.result
			if err then
				lsp.log.error(err.code, err.message)
			elseif result then
				results1[client_id] = result
			end
		end

		if vim.tbl_isempty(results1) then
			if config.silent ~= true then
				vim.notify("No information available", vim.log.levels.INFO)
			end
			return
		end

		local contents = {} --- @type string[]

		local nresults = #vim.tbl_keys(results1)

		local format = "markdown"

		for client_id, result in pairs(results1) do
			local client = assert(lsp.get_client_by_id(client_id))
			if nresults > 1 then
				-- Show client name if there are multiple clients
				contents[#contents + 1] = string.format("# %s", client.name)
			end
			if type(result.contents) == "table" and result.contents.kind == "plaintext" then
				if #results1 == 1 then
					format = "plaintext"
					contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
				else
					-- Surround plaintext with ``` to get correct formatting
					contents[#contents + 1] = "```"
					vim.list_extend(contents, vim.split(result.contents.value or "", "\n", { trimempty = true }))
					contents[#contents + 1] = "```"
				end
			else
				vim.list_extend(contents, convert_input_to_markdown_lines(result.contents))
			end
			local range = result.range
			if range then
				local start = range.start
				local end_ = range["end"]
				local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
				local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)

				vim.hl.range(
					bufnr,
					hover_ns,
					"LspReferenceTarget",
					{ start.line, start_idx },
					{ end_.line, end_idx },
					{ priority = vim.hl.priorities.user }
				)
			end
			contents[#contents + 1] = "---"
		end

		-- Remove last linebreak ('---')
		contents[#contents] = nil

		if vim.tbl_isempty(contents) then
			if config.silent ~= true then
				vim.notify("No information available")
			end
			return
		end

		local _, winid = lsp.util.open_floating_preview(contents, format, config)

		api.nvim_create_autocmd("WinClosed", {
			pattern = tostring(winid),
			once = true,
			callback = function()
				api.nvim_buf_clear_namespace(bufnr, hover_ns, 0, -1)
				return true
			end,
		})
	end)
end

return M
