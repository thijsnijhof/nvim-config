local M = {}

-- Function to setup the theme
local function setup_theme()
    -- Enable true color support
    vim.opt.termguicolors = true
    
    -- Configure Gruvbox Baby (for dark mode)
    vim.g.gruvbox_baby_background_color = 'dark'
    vim.g.gruvbox_baby_transparent_mode = true
    
    -- Configure regular Gruvbox (for light mode)
    vim.g.gruvbox_contrast_light = 'hard'
    vim.g.gruvbox_contrast_dark = 'medium'
    vim.g.gruvbox_italic = 1
    vim.g.gruvbox_italicize_comments = 1
    vim.g.gruvbox_sign_column = 'bg0'
    vim.g.gruvbox_colorcolumn = 'bg1'
    vim.g.gruvbox_improved_strings = 0
    vim.g.gruvbox_improved_warnings = 1
    
    -- Set initial theme if not set
    if vim.g.current_theme == nil then
        vim.g.current_theme = 'dark'  -- Default to dark mode
    end
    
    -- Apply the theme with proper background settings
    if vim.g.current_theme == 'light' then
        vim.opt.background = 'light'
        -- Clear any existing highlights first
        vim.cmd('highlight clear')
        vim.cmd('syntax reset')
        -- Load the colorscheme
        vim.cmd('colorscheme gruvbox')
        -- Force Gruvbox light theme colors
        vim.cmd([[
            highlight clear
            syntax reset
            set background=light
            colorscheme gruvbox
            
            highlight Normal guibg=#fbf1c7 guifg=#3c3836 ctermbg=230 ctermfg=237
            highlight LineNr guifg=#7c6f64 guibg=#f2e5bc ctermfg=243 ctermbg=187
            highlight CursorLineNr guifg=#3c3836 guibg=#f2e5bc ctermfg=237 ctermbg=187
            highlight SignColumn guibg=#f2e5bc ctermbg=187
            highlight ColorColumn guibg=#ebdbb2 ctermbg=187
            highlight CursorLine guibg=#f2e5bc ctermbg=187
            highlight CursorColumn guibg=#f2e5bc ctermbg=187
            highlight Visual guibg=#d5c4a1 ctermbg=144
            
            highlight clear StatusLine
            highlight clear StatusLineNC
            highlight clear TabLine
            highlight clear TabLineFill
        ]])
    else
        vim.opt.background = 'dark'
        vim.cmd('colorscheme gruvbox-baby')
    end
end

-- Function to toggle between light and dark mode
function M.toggle_theme()
    if vim.g.current_theme == 'light' then
        vim.g.current_theme = 'dark'
        vim.opt.background = 'dark'
        vim.cmd('colorscheme gruvbox-baby')
    else
        vim.g.current_theme = 'light'
        vim.opt.background = 'light'
        -- Clear and reset before applying light theme
        vim.cmd('highlight clear')
        vim.cmd('syntax reset')
        vim.cmd([[
            set background=light
            colorscheme gruvbox
            
            highlight Normal guibg=#fbf1c7 guifg=#3c3836 ctermbg=230 ctermfg=237
            highlight LineNr guifg=#7c6f64 guibg=#f2e5bc ctermfg=243 ctermbg=187
            highlight CursorLineNr guifg=#3c3836 guibg=#f2e5bc ctermfg=237 ctermbg=187
            highlight SignColumn guibg=#f2e5bc ctermbg=187
            highlight ColorColumn guibg=#ebdbb2 ctermbg=187
            highlight CursorLine guibg=#f2e5bc ctermbg=187
            highlight CursorColumn guibg=#f2e5bc ctermbg=187
            highlight Visual guibg=#d5c4a1 ctermbg=144
        ]])
    end
    vim.cmd('doautocmd ColorScheme | redraw!')
end

-- Plugin specifications
return {
    {
        'luisiacc/gruvbox-baby',
        lazy = false,
        priority = 1000,
        config = function()
            setup_theme()
            _G.toggle_theme = M.toggle_theme
        end
    },
    {
        'morhetz/gruvbox',
        lazy = true,
    },
}
