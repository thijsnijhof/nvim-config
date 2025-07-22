-- Tell the Lua language server that `vim` is a global variable
_G.vim = vim

-- setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- info: require where plugins > 1
local git_related = require("plugins.git_related")
local mason = require("plugins.mason")
local telescope_setup, telescope_fzf_native_setup = require("plugins.telescope")
local darcula = require("plugins.darcula")

-- info: Setup the plugins
require("lazy").setup({
    -- themes
    darcula,
    require("themes.darcula"),

    -- plugins
    require("plugins.lua_snip"),
    require("plugins.friendly_snippets"),
    require("plugins.nvim_tree"),
    require("plugins.autoclose_brackets"),

    git_related[1], -- vim fugitive
    git_related[2], -- vim rhubarb

    mason[1], mason[2],

    require("plugins.cmp"),

    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.lsp_config").setup()
        end
    },

    require("plugins.which_key"),
    require("plugins.git_signs"),
    require("plugins.lua_line"),
    require("plugins.comment"),
    require("plugins.jester"),
    require("plugins.lsp_saga"),
    require("plugins.indent_line"),
    require("plugins.editor_config"),
    require("plugins.mardown_preview"),
    require("plugins.startup"),
    require("plugins.hlslens"),
    require("plugins.cursorline"),
    require("plugins.TODO_comments"),
    require("plugins.fidget"),
    require("plugins.neoclip"),
    require("plugins.scrollbar"),
    require("plugins.cheatsheet"),
    require("plugins.git_messenger"),
    require("plugins.smear_cursor"),
    require("plugins.nvim_dap"),

    -- https://github.com/mxsdev/nvim-dap-vscode-js
    require("plugins.nvim_dap_vscode_js").setup({
     -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    debugger_path = "~/git/vscode-js-debug", -- Path to vscode-js-debug installation.
     -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
     adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
     -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
     -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
     -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    }),

    telescope_setup,
    telescope_fzf_native_setup,
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("plugins.nvim_dap").configurations[language] = {
        {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require'dap.utils'.pick_process,
                cwd = "${workspaceFolder}",
            }
        }
    }
end

-- info: general settings
require('settings')

-- info: keymaps setup
require("keymaps.general_keymaps")
require('keymaps.nvim_tree_keymaps')
require("keymaps.fzf_keymaps")
require("keymaps.jester_keymaps")
require("keymaps.lsp_saga_keymaps")
require("keymaps.neoclip_keymaps")
require("keymaps.git_keymaps")
