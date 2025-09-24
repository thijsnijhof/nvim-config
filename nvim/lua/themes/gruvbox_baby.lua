local M = {}

-- Function to toggle between light and dark mode
function M.toggle_theme()
    if vim.g.gruvbox_baby_background_color == 'light' then
        vim.g.gruvbox_baby_background_color = 'dark'
    else
        vim.g.gruvbox_baby_background_color = 'light'
    end
    vim.cmd[[colorscheme gruvbox-baby]]
end

-- Set keymap to toggle theme
vim.api.nvim_set_keymap('n', '<leader>tt', 
    [[<cmd>lua require('themes.gruvbox_baby').toggle_theme()<CR>]], 
    { noremap = true, silent = true, desc = 'Toggle between light and dark theme' })

return {
    { 'luisiacc/gruvbox-baby',
        config = function()
            vim.g.gruvbox_baby_background_color = 'dark'  -- Default to dark mode
            vim.g.gruvbox_baby_transparent_mode = true
            vim.cmd[[colorscheme gruvbox-baby]]
        end
    },
}
