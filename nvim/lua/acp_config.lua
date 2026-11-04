-- Separate from ai_config.lua: ACP commands speak a protocol, not terminal UI.
return {
    provider = vim.env.DEV_ACP_AGENT or 'codex-acp',
    windows = { position = 'right', width = '40%' },
    acp_providers = {
        ['codex-acp'] = {
            command = vim.fn.expand('~/.local/share/dev-ai/node_modules/.bin/codex-acp'),
        },
        ['kiro-acp'] = {
            command = 'kiro-cli',
            args = { 'acp' },
        },
        -- Add any ACP-compatible provider, e.g.:
        -- ['custom-acp'] = { name = 'Custom', command = '/path/to/agent', args = { '--acp' } },
    },
}
