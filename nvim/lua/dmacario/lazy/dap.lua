-- Configuration file for nvim-dap (debugger)
return{
    -- debugger: nvim-dap
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            'rcarriga/nvim-dap-ui',
            opts = {},
            config = function(_, opts)
                require("dapui").setup(opts)
                vim.keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<CR>", {noremap=true})
                vim.keymap.set("n", "<leader>dr", ":lua require('dapui').open({reset=true})<CR>", {noremap=true})
            end
        },
        {
            'mfussenegger/nvim-dap-python',
            config = function()
                require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
            end
        },
        -- virtual text for the debugger
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
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
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dT", function() require("dap").terminate() end, desc = "Terminate" },
    },

    config = function()
        local dap = require('dap')
        -- dap.setup()

        -- vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", {noremap=true})
        -- vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", {noremap=true})

        -- dap.configurations.python = {
        --   {
        --     type = 'python';
        --     request = 'launch';
        --     name = "Launch file";
        --     program = "${file}";
        --     pythonPath = function()
        --       return '/usr/bin/python'
        --     end;
        --   },
        -- }
    end
}
