-- Configuration file for nvim-dap (debugger)
return {
	{
		-- debugger: nvim-dap
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			{
				"rcarriga/nvim-dap-ui",
				opts = {},
				config = function(_, opts)
					require("dapui").setup(opts)
					vim.keymap.set("n", "<leader>dt", function()
						require("dapui").toggle()
					end, { noremap = true })
					vim.keymap.set("n", "<leader>dr", function()
						require("dapui").open({ reset = true })
					end, { noremap = true })
				end,
			},
			{
				"mfussenegger/nvim-dap-python",
			},
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
			},
			-- mason.nvim integration
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					-- Makes a best effort to setup the various debuggers with
					-- reasonable debug configurations
					automatic_installation = true,

					-- You can provide additional configuration to the handlers,
					-- see mason-nvim-dap README for more information
					handlers = {},

					-- You'll need to check that you have the required things installed
					-- online, please don't ask me how to install them :)
					ensure_installed = {
						-- Update this to ensure that you have the debuggers for the langs you want
					},
				},
			},
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
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
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
			local dap = require("dap")
			local ui = require("dapui")
			local virtual_text = require("nvim-dap-virtual-text")

			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

			ui.setup()
			virtual_text.setup()

			vim.keymap.set("n", "<leader>?", function()
				ui.eval(nil, { enter = true })
			end)
		end,
	},
}
