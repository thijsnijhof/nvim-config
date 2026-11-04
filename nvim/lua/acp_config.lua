local machine = require('machine').acp
-- Separate from ai_config.lua: ACP commands speak a protocol, not terminal UI.
return {
    provider = vim.env.DEV_ACP_AGENT or machine.provider,
    windows = { position = 'right', width = '40%' },
    acp_providers = vim.tbl_deep_extend('force', {
        ['codex-acp'] = {
            command = 'codex-acp',
        },
        ['kiro-acp'] = {
            command = 'kiro-cli',
            args = { 'acp' },
        },
        -- Add any ACP-compatible provider, e.g.:
        -- ['custom-acp'] = { name = 'Custom', command = '/path/to/agent', args = { '--acp' } },
    }, machine.providers),
}
