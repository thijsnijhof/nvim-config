return {
    'carlos-algms/agentic.nvim',
    commit = 'f0bef086b3ed6121d9a18a5a820d071c69f2f0f5',
    opts = function()
        return require('acp_config')
    end,
    keys = {
        { '<F8>', function() require('agentic').toggle() end, desc = 'ACP: Toggle chat' },
        { '<leader>icc', function() require('agentic').toggle() end, desc = 'ACP: Toggle chat' },
        { '<leader>icf', function() require('agentic').add_selection_or_file_to_context() end,
            mode = { 'n', 'v' }, desc = 'ACP: Add file/selection' },
        { '<leader>icn', function() require('agentic').new_session() end, desc = 'ACP: New session' },
        { '<leader>icr', function() require('agentic').restore_session() end, desc = 'ACP: Restore session' },
        { '<leader>icp', function() require('agentic').switch_provider() end, desc = 'ACP: Choose provider' },
        { '<leader>icd', function() require('agentic').add_current_line_diagnostics() end, desc = 'ACP: Add line diagnostics' },
        { '<leader>icD', function() require('agentic').add_buffer_diagnostics() end, desc = 'ACP: Add buffer diagnostics' },
    },
}
