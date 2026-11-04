# Native AI agents in tmux

Run Neovim from the project directory inside tmux. This integration opens a
40% right-hand pane running the selected CLI in the editor pane's working
directory. It reuses a live pane for that provider in the same tmux window.
Switching providers preserves existing panes and conversations; it does not
transfer conversation context. Close agent panes normally when finished.

## Home: Codex

Codex is currently available on this Mac through the ChatGPT application and
`codex login status` reports ChatGPT authentication. No separate install or
login was performed by this setup. Check `command -v codex` in your normal
terminal too; the desktop app's environment can differ from iTerm2.

If unavailable there, install the standalone CLI following
https://developers.openai.com/codex/cli/ and run `codex login`.

```sh
cd /path/to/project
tmux new-session -s project
nvim .
```

Codex is the default. Normal CLI approval and sandbox settings are preserved.
No unattended prompts are submitted by the editor integration.

## Work: Kiro

Install/authenticate Kiro CLI using your work setup. It must provide
`kiro-cli chat` on PATH. Kiro is not installed in this Mac's current environment,
so its interactive behavior remains unverified here.

Set this in your work machine's shell configuration, or just for one invocation:

```sh
export DEV_AI_AGENT=kiro
```

For a single Neovim invocation: `DEV_AI_AGENT=kiro nvim .`.
No provider is inferred from project contents. If Kiro is missing, the shortcut
shows an error and does not launch Codex instead.

## Shortcuts

| Key | Action |
| --- | --- |
| Space ii | Open/focus the selected agent pane |
| Space ip | Choose any configured CLI for this Neovim session |
| Space if | Copy absolute file path and current line |
| Space is (visual) | Copy selection with file/line context |
| Space id | Copy diagnostics for the current buffer |

Copy context, open the pane, then paste with your terminal's paste shortcut
(Command-V in iTerm2). Review and submit in the agent itself. Unsaved selections
are copied from the buffer; a path alone refers to the file on disk.
Clipboard context is not sent anywhere until you paste/submit it yourself.

Use your tmux prefix followed by `;` to return to the previous pane, or prefix
plus an arrow to navigate panes. With an unchanged tmux prefix, this is Ctrl-b.
This step adds focus/open, not a hide/show toggle or seamless Ctrl-h/j/k/l
navigation; those can be added once this basic flow is tested.

The integration is loaded by init.lua and needs no AI plugin. Activate it with
the repository's normal copy.sh deployment, then restart Neovim in tmux.

## Configure any CLI

Edit `nvim/lua/ai_config.lua`: add an agent name and an argument list, for example
`claude = { 'claude' }` or `local_agent = { '/path/to/tool', '--interactive' }`.
The integration contains no provider-specific protocol. Use `default` for the
normal choice, `DEV_AI_AGENT` for a machine/session override, or Space ip to
choose any configured agent. Executables must be installed and authenticated
separately. Arbitrary shell snippets are intentionally not evaluated; use a
wrapper executable for commands requiring special environment setup.

## Agentic.nvim: optional ACP interface

Installed alongside the native terminal launcher. No tmux session is needed for
Agentic itself. `Space icc` opens the chat; type in the prompt buffer with `i`,
then use Ctrl-s, or Esc followed by Enter, to submit. The chat is a regular
Neovim buffer, so normal scrolling/navigation works there.

`Space icf` adds the file or visual selection, `Space icp` selects a provider,
`Space icn` starts a new session, and `Space icr` restores a session.
`Space icd` / `Space icD` adds line / buffer diagnostics. Existing terminal
shortcuts, including Space ii, remain separate.

Configure provider commands in `nvim/lua/acp_config.lua`. Override the startup
provider with `DEV_ACP_AGENT=kiro-acp nvim .` on a work machine with Kiro
installed. Kiro is configured as `kiro-cli acp` but has not been tested here.
Add any other ACP-compatible command under `acp_providers`.

Agentic is pinned to f0bef086b3ed6121d9a18a5a820d071c69f2f0f5.
Codex ACP is pinned to @agentclientprotocol/codex-acp@2.5.0, installed with:

```sh
npm install --prefix ~/.local/share/dev-ai --save-exact @agentclientprotocol/codex-acp@2.5.0
```

The adapter uses its packaged compatible Codex dependency. It does not rely
on the ChatGPT application's private binary path. Existing ChatGPT login was
accepted in the setup check. No API key was configured. ACP initialization and
session creation were verified; a model prompt was not submitted during setup.
Review permission requests in the Agentic UI; no automatic permission bypass
is configured.
