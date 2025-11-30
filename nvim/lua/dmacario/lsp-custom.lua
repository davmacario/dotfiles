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
--- Most of the code is a copy-paste from nvim/runtime/lua/vim/lsp/util.lua
--- on Nvim v0.11.4
---
--- In the future, hopefully there will be some easier way to make such changes

--- Splits string at newlines, optionally removing unwanted blank lines.
---
---@param s string Multiline string
---@param no_blank boolean? Drop blank lines for each @param/@return (except one empty line
--- separating each). Workaround for https://github.com/LuaLS/lua-language-server/issues/2333
local function split_lines(s, no_blank)
	s = string.gsub(s, "\r\n?", "\n")

	--- NOTE: only difference is here!
	--- Explicitly replace "weird" glyphs
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

--- Override
vim.lsp.util.convert_input_to_markdown_lines = convert_input_to_markdown_lines
