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
			Sample_Prompt = {
				prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
				input_label = "> ",
				model = "llama3",
				action = "display",
			},
		},
	},
}
