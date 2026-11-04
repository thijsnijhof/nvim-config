# Neovim + tmux development environment

Shared modular Neovim config, tmux navigation/theme, configurable terminal AI
agents and optional ACP chat. Neovim remains usable without AI.

## Deploy on this Mac

```sh
cd ~/projects/nvim-config
./copy.sh --dry-run
./copy.sh --profile home
```

The checkout may live anywhere. copy.sh resolves its own location, so it also
works when called from another directory. Requires Python 3.

Deployment links `~/.config/nvim` to the checkout's nvim directory and
`~/.config/dev-setup` to the checkout. It adds a managed block to ~/.tmux.conf,
preserving unrelated settings. XDG_CONFIG_HOME and XDG_STATE_HOME are respected.
An existing installed config is moved, not deleted, under
`~/.local/state/dev-setup/backups/<timestamp>/`. tmux settings are backed up too.
Repeated runs preserve the existing local configuration and correct symlinks.

Restart Neovim after deployment or pulling shared config changes. Reload tmux:

```sh
tmux source-file ~/.tmux.conf
```

**No copying is needed after editing or pulling the checkout.** Active Neovim
files are the repository files; edits and lazy.nvim lockfile updates appear in
Git status. Review before committing. No commits or pushes are automated.

## Work machine

Clone this repository outside ~/.config/nvim, then run:

```sh
./copy.sh --profile work
./copy.sh --check
```

`--profile` chooses the initial local settings only. Once that file exists,
changing --profile does not replace it. Edit it directly to switch machines'
defaults. The work example selects Kiro for terminal and ACP; the home example
selects Codex. No agent credentials are copied or installed by deployment.

## Machine-specific settings

Edit `~/.config/dev-setup.local.lua` (or the XDG_CONFIG_HOME equivalent).
This file is outside the checkout and never overwritten by setup. The examples
show the supported settings:

- `ai.default` and `ai.agents`: terminal agent and command argument lists.
- `acp.provider` and `acp.providers`: any ACP provider and executable/arguments.
- `godot.command`: engine executable.
- `formatting.gdformat`: formatter executable.

Environment overrides remain available: DEV_AI_AGENT, DEV_ACP_AGENT, GODOT_BIN,
GDScript_Port. For the external-editor bridge, set NVIM_BIN if nvim is not on
Godot's PATH. Use full executable paths for GUI-launched processes if needed.
The home example detects this Mac's bundled Codex and private ACP installation;
change those paths on other machines. It contains no credentials.

## Prerequisites and optional tools

Run `./copy.sh --check` to report tools and deployment status. It is read-only.
It does not install or upgrade anything. Core requirements: Neovim >=0.11.3,
tmux, Git, ripgrep, make and a compiler for native parsers/extensions. Node/npm
are needed by several language tools and the Codex ACP adapter.
On first Neovim startup lazy.nvim installs missing configured plugins; use
`:Lazy restore` to install versions from lazy-lock.json. Mason handles the
explicitly configured language servers. PHP/Phpactor also needs local PHP.
Install/authenticate only the agents you use, using their own instructions.

Formatters: `:MasonInstall prettier stylua shfmt php-cs-fixer`.
GDScript formatting: install gdtoolkit separately and configure gdformat's path.
The project already has make format/make lint; retain its conventions.
ACP adapter installation and shortcuts are in AI.md. Godot setup is in GODOT.md.

## Themes

Import themes/Neon Dusk.itermcolors through iTerm2 Color Presets. Profile fonts,
background images and opacity are machine-local preferences; deployment does
not replace iTerm2 settings. themes/neovim_bg.png is available as a background.
tmux's palette is included by deployment. F12 toggles the Neovim background.

## Rollback

Quit Neovim. The backup directory contains the complete previous installed
config under its original absolute path (without the leading slash). Remove
only the ~/.config/nvim symlink and move that backup back into place. Restore
backup's tmux.conf if reverting the tmux block. The checkout and local settings
remain available; setup never deletes old backup directories.

Legacy nvim/README.md sections referring to copying describe the old deployment;
this root README is authoritative for installation and machine configuration.
