-- Machine-local file: edit freely; deployment never overwrites an existing copy.
local bundled = '/Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS/codex'
local acp = vim.fn.expand('~/.local/share/dev-ai/node_modules/.bin/codex-acp')
return {
    ai = { default = 'codex', agents = { codex = { vim.fn.executable('codex') == 1 and 'codex' or bundled } } },
    acp = { provider = 'codex-acp', providers = {
        ['codex-acp'] = { command = vim.fn.executable(acp) == 1 and acp or 'codex-acp' },
    } },
    godot = { command = vim.fn.expand('~/Documents/Godot.app/Contents/MacOS/Godot') },
    formatting = { gdformat = vim.fn.executable('gdformat') == 1 and 'gdformat'
        or vim.fn.expand('~/Library/Python/3.9/bin/gdformat') },
}
