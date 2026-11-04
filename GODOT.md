# Godot + Neovim

Test project: `~/projects/2000s-survivors-prototype`.
Godot executable found: `~/Documents/Godot.app/Contents/MacOS/Godot` (4.7.1).
The game project itself was not modified.

## Start

Open a `.gd` file in Neovim, then use Space oge to open the project's Godot
editor. Godot must keep the same project open for LSP support. If the script
was opened before Godot started, run `:LspStart gdscript` afterward.
Use `:checkhealth vim.lsp` to verify attachment, `gd` for definition, `gr` for
references, K for hover, and normal completion/rename shortcuts.

Godot hosts LSP on 127.0.0.1:6005 by default. Match the editor's Network >
Language Server > Remote Port setting. Set GDScript_Port before launching
Neovim to override it. Only one project should own that port at a time.

## Shortcuts

- Space oge: open Godot editor for the current project.
- Space ogr: run the saved project.
- Space ogs: choose a saved .tscn scene to run.
- Space fr: format GDScript using gdformat.

Run shortcuts use saved files, do not save buffers automatically, and launch
independent Godot processes; close the game window normally when finished.
Configure GODOT_BIN for a different installation.

The existing gdformat installation is used, with a local Mac Python 3.9 path
fallback. Other machines should install gdtoolkit and put gdformat on PATH.
Project-wide `make format` and `make lint` remain the project's checks.

## Open scripts from Godot in the existing Neovim

Open a .gd file in this project in Neovim first. The bridge starts a Unix
socket specific to the project in /tmp. In Godot's Editor Settings configure:

Text Editor > External:

- Use External Editor: enabled
- Exec Path: `/Users/tnijhof/projects/nvim-config/scripts/godot-nvim`
- Exec Flags: `"{project}" "{file}" {line} {col}`

Text Editor > Behavior:

- Auto Reload Scripts on External Change: enabled

Now opening a script in Godot targets that project's running Neovim and jumps
to its line and column. The bridge requires python3 and nvim; it does not start
a separate editor if none is running. If multiple Neovims edit the same project,
only one can own its bridge socket. These Godot preferences were not modified
automatically.

## Verification and remaining work

Verified project/executable discovery, run argument construction, mappings,
and bridge syntax. Live LSP navigation requires Godot to be open; port 6005
was not listening during setup. Gameplay and engine settings were not changed.
Godot DAP debugging is a separate next step, after confirming LSP works.
