return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			automatic_installation = true,
			handlers = {},
			ensure_installed = {
				"codelldb",
				"debugpy",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		event = "VeryLazy",
		config = function(_, opts)
			local dap = require("dap")
			local ui = require("dapui")
			ui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				ui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				ui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				ui.close()
			end

			vim.keymap.set("n", "<leader>dt", function()
				ui.toggle()
			end, { noremap = true, desc = "Toggle DAP UI" })
			vim.keymap.set("n", "<leader>dr", function()
				ui.open({ reset = true })
			end, { noremap = true, desc = "Reset DAP UI view" })
			vim.keymap.set("n", "<leader>?", function()
				ui.eval(nil, { enter = true })
			end, { noremap = true })
		end,
	},
	{
		-- debugger: nvim-dap
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint on current line",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run debugger/continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dT",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
		},

		config = function()
			require("nvim-dap-virtual-text").setup()
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
		end,
	},
}
