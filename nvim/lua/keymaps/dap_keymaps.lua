-- DAP (Debug Adapter Protocol) keymaps

local dap = require('dap')
local dapui = require('dapui')

-- Basic debugging keymaps
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug: Set Conditional Breakpoint' })

-- DAP UI keymaps
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result' })

-- Advanced debugging keymaps
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open REPL' })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
vim.keymap.set('n', '<leader>dc', dap.clear_breakpoints, { desc = 'Debug: Clear All Breakpoints' })

-- Hover and evaluate
vim.keymap.set({'n', 'v'}, '<leader>dh', require('dap.ui.widgets').hover, { desc = 'Debug: Hover Variables' })
vim.keymap.set({'n', 'v'}, '<leader>dp', require('dap.ui.widgets').preview, { desc = 'Debug: Preview Variables' })

-- Frames and scopes
vim.keymap.set('n', '<leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end, { desc = 'Debug: Show Frames' })

vim.keymap.set('n', '<leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end, { desc = 'Debug: Show Scopes' })
