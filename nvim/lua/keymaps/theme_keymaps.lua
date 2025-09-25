-- Toggle between light (Gruvbox) and dark (Gruvbox Baby) theme
local function toggle_theme()
    if vim.g.current_theme == 'light' then
        -- Switch to dark mode (Gruvbox Baby)
        vim.g.current_theme = 'dark'
        vim.g.gruvbox_contrast_dark = 'medium'
        vim.opt.background = 'dark'
        vim.cmd('colorscheme gruvbox-baby')
    else
        -- Switch to light mode (Gruvbox)
        vim.g.current_theme = 'light'
        vim.g.gruvbox_contrast_light = 'soft'
        vim.opt.background = 'light'
        vim.cmd('colorscheme gruvbox')
    end
    
    -- Force redraw
    vim.cmd('highlight clear')
    vim.cmd('syntax reset')
    vim.cmd('doautocmd ColorScheme')
    vim.cmd('redraw!')
end

-- Initialize the theme if not set
if vim.g.current_theme == nil then
    vim.g.current_theme = 'dark'  -- Default to dark mode
    vim.cmd('colorscheme gruvbox-baby')
end

-- Set up the theme toggle keymap to use the global toggle_theme function
vim.keymap.set('n', '<F12>', '<cmd>lua _G.toggle_theme()<CR>', 
    { noremap = true, silent = true, desc = 'Toggle between light (Gruvbox) and dark (Gruvbox Baby) theme' })
