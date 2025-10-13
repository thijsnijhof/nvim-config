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
-- local darcula = require("plugins.darcula")

-- info: Setup the plugins
require("lazy").setup({
   -- themes
   --darcula,
    -- require("themes.darcula"),
    require("themes.gruvbox_baby"),

    -- plugins
    require("plugins.lua_snip"),

    require("plugins.friendly_snippets"),

    require("plugins.nvim_tree"),

    require("plugins.autoclose_brackets"),

    git_related[1], -- vim fugitive
    git_related[2], -- vim rhubarb

    mason[1], mason[2],

    require("plugins.cmp"),
    
    -- Inlay hints on current line
    require("plugins.inlay_hints"),
    
    -- Docker
    require("plugins.docker"),
    
    -- PHP development
    {
        'neovim/nvim-lspconfig',
        ft = 'php',
        config = function()
            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            
            lspconfig.phpactor.setup {
                cmd = { os.getenv('HOME') .. '/.composer/vendor/bin/phpactor', 'language-server' },
                on_attach = function(client, bufnr)
                    -- Your on_attach configuration here
                    local bufopts = { noremap=true, silent=true, buffer=bufnr }
                    vim.keymap.set('n', '<leader>cf', function()
                        vim.lsp.buf.references({
                            includeDeclaration = false,
                            bufnr = bufnr
                        })
                    end, vim.tbl_extend('force', bufopts, { desc = 'Find references (optimized)' }))
                end,
                capabilities = capabilities,
                settings = {
                    phpactor = {
                        maxMemory = '4G',
                        enableLanguageServer = true,
                        indexingEnabled = true,
                        completionEnabled = true,
                        indexingExclude = {
                            'vendor',
                            'node_modules',
                            'tests',
                            'var',
                            'cache',
                            'build',
                            'tmp',
                        },
                        references = {
                            ignoreHidden = true,
                            ignoreVendors = true,
                            ignoreTests = true,
                            limit = 100
                        }
                    }
                }
            }
        end
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("plugins.lsp_config").setup()
        end
    },

    require("plugins.copilot"),
    require("plugins.copilot_chat"),
    
    require("plugins.which_key"),

    require("plugins.git_signs"),

    require("plugins.lua_line"),

    require("plugins.comment"),

    require("plugins.tree_sitter"),

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

    --require("plugins.vim-dadbod-ui"),

    -- DAP (Debug Adapter Protocol)
    require("plugins.nvim_dap"),
    require("plugins.nvim_dap_ui"),

    telescope_setup,
    telescope_fzf_native_setup,
    -- add more
})



-- info: general settings
require('settings')



-- info: keymaps setup
require("keymaps.theme_keymaps")
require("keymaps.general_keymaps")
require('keymaps.nvim_tree_keymaps')
require("keymaps.fzf_keymaps")
require("keymaps.jester_keymaps")
require("keymaps.lsp_saga_keymaps")
require("keymaps.neoclip_keymaps")
require("keymaps.git_keymaps")
require("keymaps.dap_keymaps")
