-- Tell the Lua language server that `vim` is a global variable
_G.vim = vim

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
local telescope = require("plugins.telescope")
-- local darcula = require("plugins.darcula")

-- info: Setup the plugins
require("lazy").setup({
   -- themes
   --darcula,
    -- require("themes.darcula"),
    -- Neon Dusk is a local colorscheme; Gruvbox files remain available.

    -- plugins
    require("plugins.lua_snip"),

    require("plugins.friendly_snippets"),

    require("plugins.nvim_tree"),

    require("plugins.autoclose_brackets"),

    git_related[1], -- vim fugitive
    git_related[2], -- vim rhubarb

    require("plugins.cmp"),
    
    require("plugins.lsp"),
    require("plugins.formatting"),
    require("plugins.docker"),

    -- require("plugins.copilot"),
    -- require("plugins.copilot_chat"),
    
    require("plugins.which_key"),

    require("plugins.git_signs"),

    require("plugins.lua_line"),

    require("plugins.comment"),

    require("plugins.tree_sitter"),

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

    --require("plugins.vim-dadbod-ui"),

    -- DAP (Debug Adapter Protocol)
    require("plugins.nvim_dap"),
    require("plugins.nvim_dap_ui"),

    telescope,
    -- add more
})



-- info: general settings
require('settings')



vim.cmd.colorscheme("neon_dusk")

-- info: keymaps setup
require("keymaps.theme_keymaps")
require("keymaps.general_keymaps")
require('keymaps.nvim_tree_keymaps')
require("keymaps.fzf_keymaps")
require("keymaps.lsp_saga_keymaps")
require("keymaps.neoclip_keymaps")
require("keymaps.git_keymaps")
require("keymaps.dap_keymaps")
