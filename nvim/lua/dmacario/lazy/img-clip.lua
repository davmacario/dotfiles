return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	config = function()
		require("img-clip").setup({
			default = {
				-- file and directory options
				dir_path = "assets",
				extension = "png",
				file_name = "%Y-%m-%d-%H-%M-%S",
				use_absolute_path = false,
				relative_to_current_file = false,

				-- template options
				template = "$FILE_PATH",
				url_encode_path = false,
				relative_template_path = true,
				use_cursor_in_template = true,
				insert_mode_after_paste = true,

				-- prompt options
				prompt_for_file_name = true,
				show_dir_path_in_prompt = true,

				-- base64 options
				max_base64_size = 10,
				embed_image_as_base64 = false,

				-- image options
				process_cmd = "",
				copy_images = false,
				download_images = true,

				-- drag and drop options
				drag_and_drop = {
					enabled = true,
					insert_mode = false,
				},
			},
		})
		vim.keymap.set(
			"n",
			"<leader>ip",
			vim.cmd.PasteImage,
			{ noremap = true, desc = "Paste image from system clipboard" }
		)
	end,
	keys = { "<leader>ip" },
}
