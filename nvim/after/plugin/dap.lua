-- Configuration file for nvim-dap (debugger)

require("dapui").setup()

vim.keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<CR>", {noremap=true})
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", {noremap=true})
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", {noremap=true})
vim.keymap.set("n", "<leader>dr", ":lua require('dapui').open({reset=true})<CR>", {noremap=true})

local dap = require('dap')
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

-- Python config
require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
-- require('dap-python').setup('/usr/bin/python')
