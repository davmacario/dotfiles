return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			-- display.chat.show_settings = true
			display = {
				action_palette = {
					prompt = "Prompt ",
					provider = "telescope",
					opts = {
						show_default_actions = true,
						show_default_prompt_library = true,
					},
				},
				chat = {
					show_settings = true,
					show_header_separation = true,
					-- Change the default icons
					icons = {
						pinned_buffer = " ",
						watched_buffer = "👀 ",
					},

					-- Alter the sizing of the debug window
					debug_window = {
						---@return number|fun(): number
						width = vim.o.columns - 5,
						---@return number|fun(): number
						height = vim.o.lines - 2,
					},

					keymaps = {
						send = {
							modes = { n = "<C-s>", i = "<C-s>" },
						},
						close = {
							modes = { n = "<C-c>", i = "<C-c>" },
						},
					},

					-- Options to customize the UI of the chat buffer
					window = {
						layout = "vertical", -- float|vertical|horizontal|buffer
						position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
						border = "single",
						height = 0.8,
						width = 0.30,
						relative = "editor",
						opts = {
							breakindent = true,
							cursorcolumn = false,
							cursorline = false,
							foldcolumn = "0",
							linebreak = true,
							list = false,
							numberwidth = 1,
							signcolumn = "no",
							spell = false,
							wrap = true,
						},
					},
				},
			},
			system_prompt = function() -- Passed to the LLM in chat mode
				return [[
				You are an AI programming assistant named "CodeCompanion". You are currently plugged in to text editor on a user's machine.

				Your core tasks include:
				- Answering general programming questions.
				- Explaining how the code in a Neovim buffer works.
				- Reviewing the selected code in a Neovim buffer.
				- Generating unit tests for the selected code.
				- Proposing fixes for problems in the selected code.
				- Scaffolding code for a new workspace.
				- Finding relevant code to the user's query.
				- Proposing fixes for test failures.
				- Answering questions about Neovim.
				- Running tools.

				You must:
				- Follow the user's requirements carefully and to the letter.
				- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
				- Minimize other prose.
				- Use Markdown formatting in your answers.
				- Include the programming language name at the start of the Markdown code blocks.
				- Avoid including line numbers in code blocks.
				- Avoid wrapping the whole response in triple backticks.
				- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
				- Use actual line breaks instead of '\n' in your response to begin new lines.
				- Use '\n' only when you want a literal backslash followed by a character 'n'.
				- All non-code responses must be in %s.

				When given a task:
				1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
				2. Output the code, if any, in a single code block, being careful to only return relevant code.
				3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
				4. You can only give one reply for each conversation turn.]]
			end,
			adapters = {
				qwen2_5_coder = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen2.5-coder:7b",
						env = {
							url = "http://100.91.137.78:11435",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
						schema = {
							model = {
								default = "qwen2.5-coder:7b",
							},
						},
					})
				end,
				deepseek_r1_14b = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "deepseek-r1:14b",
						env = {
							url = "http://100.91.137.78:11435",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
						schema = {
							model = {
								default = "deepseek-r1:14b",
							},
						},
					})
				end,
				llama3_1 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "llama3.1",
						env = {
							url = "http://100.91.137.78:11435",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
						schema = {
							model = {
								default = "llama3.1",
							},
						},
					})
				end,
				codestral = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "codestral",
						env = {
							url = "http://100.91.137.78:11435",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
						schema = {
							model = {
								default = "codestral",
							},
							num_ctx = {
								default = 16384,
							},
							num_predict = {
								default = -1,
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "deepseek_r1_14b",
				},
				inline = {
					adapter = "codestral",
				},
			},
		})
		vim.cmd([[cab cc CodeCompanion]])
		vim.cmd([[cab ccc CodeCompanionChat]])
		vim.cmd([[cab cca CodeCompanionActions]])
	end,
}
