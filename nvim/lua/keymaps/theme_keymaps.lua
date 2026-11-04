-- F12 toggles the editor background for iTerm2 transparency.
vim.keymap.set('n', '<F12>', function()
    vim.g.neon_dusk_transparent = not vim.g.neon_dusk_transparent
    vim.cmd.colorscheme('neon_dusk')
end, { desc = 'Toggle transparent theme background' })
