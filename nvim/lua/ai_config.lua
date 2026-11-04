-- Add any interactive terminal CLI here. Arguments are separate strings,
-- not a shell command: no shell expansion, pipes, or automatic installation.
return {
    default = 'codex', -- Override per machine/session with DEV_AI_AGENT.
    agents = {
        -- This Mac uses the CLI bundled with ChatGPT. Use { 'codex' } on other machines.
        codex = { '/Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS/codex' },
        kiro = { 'kiro-cli', 'chat' },
        -- claude = { 'claude' },
        -- custom = { '/absolute/path/to/agent', '--some-option' },
    },
}
