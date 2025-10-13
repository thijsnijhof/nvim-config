-- https://github.com/glepnir/lspsaga.nvim

return {
    'glepnir/lspsaga.nvim',
    config = function()
        require('lspsaga').setup({
            symbol_in_winbar = {
                enable = true,
            },

            implement = {
                enable = true,
                sign = true,
                priority = 100,
            },

            lightbulb = {
                virtual_text = false,
            },
        })
        
        -- Note: LSP server configurations are handled in lsp_config.lua
        -- This file only configures LSP Saga's UI features
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons' -- optional
    }
}
