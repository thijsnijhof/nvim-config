# Neovim configuration

Copy this directory to ~/.config/nvim using the repository's copy.sh when ready.
The repository and installed configuration are separate copies.

## Language servers

`lua/plugins/lsp.lua` declares LSP dependencies; `lsp_config.lua` is the sole
setup entry point. Neovim 0.11+ is required. Mason installs the listed servers;
automatic enabling is disabled so only the explicit server list starts.

PHP uses Phpactor through nvim-lspconfig's standard command (`phpactor
language-server`) and project root detection. Install PHP locally as required
by Phpactor; the application may still run in Docker. There are no custom
indexing exclusions, reference limits, Composer-home paths, or generated
Phpactor project files. Keep dependencies accessible in the local checkout for
accurate navigation. Performance on the legacy project remains unverified.

To verify PHP when a project is available:

1. Open a PHP file in the project and run `:checkhealth vim.lsp`.
2. Confirm exactly one Phpactor client is attached and its root is the intended
   project rather than a parent containing unrelated repositories.
3. Allow initial indexing, then check `gd`, `gr`, and Lspsaga's `Space cf`.
4. If navigation remains slow, inspect `:LspLog` before adding tuning options.

## Formatting

`Space fr` formats the current document manually through Conform.
There is no format-on-save and no LSP formatting fallback.

| File type | Formatter | Mason package |
| --- | --- | --- |
| JavaScript/TypeScript, JSON, YAML, Markdown | Prettier | prettier |
| Lua | StyLua | stylua |
| Bash/shell | shfmt | shfmt |
| PHP | PHP-CS-Fixer | php-cs-fixer |

Install these explicitly with `:MasonInstall prettier stylua shfmt php-cs-fixer`.
Conform uses its standard executable discovery, including supported project-local
executables. Existing project formatting rules should be reviewed before use,
especially in the legacy PHP project. PHP-CS-Fixer cache writing is disabled.
`:ConformInfo` shows executable availability. Missing tools produce a warning
instead of silently falling back to a different formatter.

## Shortcut changes

- F3: file tree toggle; F4: reveal current file; F9: toggle ignored files.
- F5: debug start/continue; F1: step into; F2: step over; F6: step out;
  F7: debug UI.
- Space gB: open full Git blame; Space gb: toggle inline blame.
- Space gM: existing merge "both" action (sequential diffget operations, not
  automatic concatenation; review the result).
- Space oca/ocb/ocu/ocd/ocl: container attach/build/up/down/logs. These keys
  load the container plugin, so they work before any container command is run.

Jester and the project-specific Apollo launch entry have been removed.
Project debugger settings belong in the project's `.vscode/launch.json`;
load trusted project settings explicitly with
`:lua require('dap.ext.vscode').load_launchjs()`.
No Apollo project has been modified or recreated.
