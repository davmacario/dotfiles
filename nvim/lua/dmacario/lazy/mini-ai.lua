return {
	"echasnovski/mini.ai",
	version = "*",
	config = function()
		require("mini.ai").setup({
			custom_textobjects = {
				-- Delete inside funciton call
				f = require("mini.ai").gen_spec.function_call({ name_pattern = "[%w_]" }),
				-- Delete in function definition
				F = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				-- Delete all file
				g = function()
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line("$"),
						col = math.max(vim.fn.getline("$"):len(), 1),
					}
					return { from = from, to = to }
				end,
			},

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Main textobject prefixes
				around = "a",
				inside = "i",

				-- Next/last textobjects
				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",

				-- Move cursor to corresponding edge of `a` textobject
				goto_left = "g[",
				goto_right = "g]",
			},

			-- Number of lines within which textobject is searched
			n_lines = 50,

			-- How to search for object (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'prev', 'nearest'.
			search_method = "cover_or_next",

			-- Whether to disable showing non-error feedback
			-- This also affects (purely informational) helper messages shown after
			-- idle time if user input is required.
			silent = false,
		})
	end,
}
