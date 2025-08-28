-- https://github.com/mfussenegger/nvim-dap
-- Debug Adapter Protocol client implementation for Neovim
--
-- USAGE EXAMPLES:
--
-- JavaScript/TypeScript Debugging:
-- 1. Open a .js or .ts file
-- 2. Set breakpoints with <leader>b
-- 3. Press <F5> and select "Launch" to run the current file
-- 4. Or select "Attach to process" to attach to a running Node.js process
--
-- PHP Debugging with Xdebug:
-- 1. Ensure Xdebug is installed and configured in your PHP environment:
--    - Add to php.ini: zend_extension=xdebug
--    - xdebug.mode=debug
--    - xdebug.start_with_request=yes
--    - xdebug.client_port=9003
-- 2. Open a .php file and set breakpoints with <leader>b
-- 3. For web debugging: Press <F5> and select "Listen for Xdebug", then trigger your web request
-- 4. For CLI debugging: Press <F5> and select "Launch currently open script"
--
-- General Debugging Workflow:
-- - <F5>: Start/Continue debugging
-- - <F1>: Step into function
-- - <F2>: Step over line
-- - <F3>: Step out of function
-- - <leader>b: Toggle breakpoint
-- - <leader>B: Set conditional breakpoint
-- - <F7>: Toggle debug UI
-- - <leader>dt: Terminate debugging session
--
-- Prerequisites:
-- - Install debug adapters via Mason:
--   :Mason -> search for "node-debug2-adapter" and "php-debug-adapter"

local M = {}

function M.setup()
    local dap = require('dap')
    
    -- Node.js debugging (requires vscode-node-debug2)
    dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = {os.getenv('HOME') .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'},
    }
    
    dap.configurations.javascript = {
        {
            name = 'Launch',
            type = 'node2',
            request = 'launch',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
        },
        {
            name = 'Attach to process',
            type = 'node2',
            request = 'attach',
            processId = require'dap.utils'.pick_process,
        },
    }
    
    dap.configurations.typescript = dap.configurations.javascript
    
    -- PHP debugging (requires Xdebug)
    dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js' }
    }
    
    dap.configurations.php = {
        {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug',
            port = 9003,
            log = false,
            pathMappings = {
                ["/var/www/html"] = "${workspaceFolder}"
            }
        },
        {
            type = 'php',
            request = 'launch',
            name = 'Launch currently open script',
            program = '${file}',
            cwd = '${fileDirname}',
            port = 9003,
            runtimeArgs = {
                '-dxdebug.start_with_request=yes'
            },
            env = {
                XDEBUG_MODE = 'debug,develop',
                XDEBUG_CONFIG = 'client_port=9003'
            }
        }
    }
    
    -- Signs for breakpoints
    vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapBreakpointCondition', {text='🟡', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapLogPoint', {text='🔵', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapStopped', {text='▶️', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})
end

return {
    "mfussenegger/nvim-dap",
    config = function()
        M.setup()
    end,
    dependencies = {
        "nvim-neotest/nvim-nio"
    }
}
