return {
	"nomnivore/ollama.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},

	-- All the user commands added by the plugin
	cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

	keys = {
		-- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
		{
			"<leader>OO",
			":<c-u>lua require('ollama').prompt()<cr>",
			desc = "ollama prompt",
			mode = { "n", "v" },
		},

		-- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
		{
			"<leader>OG",
			":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
			desc = "ollama Generate Code",
			mode = { "n", "v" },
		},
	},

	---@type Ollama.Config
	opts = {
		model = "codestral",
		url = "http://100.91.137.78:11434",
		serve = {
			command = "docker",
			args = {
				"run",
				"-d",
				"--rm",
				"--gpus=all",
				"-v",
				"ollama:/root/.ollama",
				"-p",
				"11434:11434",
				"--name",
				"ollama",
				"ollama/ollama",
			},
			stop_command = "docker",
			stop_args = { "stop", "ollama" },
		},
		-- View the actual default prompts in ./lua/ollama/prompts.lua
		prompts = {
			Chatbot = {
				prompt = "You are a helpful chatbot that can will reply promptly and provide an effective and clear response. What follows is the user prompt:\n$input",
				input_label = "> ",
				model = "llama3",
				action = "display",
			},
      Coding_question = {
        prompt = "You are a coding assistant that will help the user by providing a clear response to his question related to coding and programming.\nUser: $input",
        input_label = "> ",
        model = "codestral",
        action = "display",
      },
		},
	},
}
