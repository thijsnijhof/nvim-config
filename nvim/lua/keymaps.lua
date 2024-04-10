-- common options
local options = {
	noremap = true, -- non-recursive
	silent = false, -- show message
}

-- ----------- --
-- Normal Mode --
-- ----------- --
-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', options)
vim.keymap.set('n', '<C-j>', '<C-w>j', options)
vim.keymap.set('n', '<C-k>', '<C-w>k', options)
vim.keymap.set('n', '<C-l>', '<C-w>l', options)
-- Resizing
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', options)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', options)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', options)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', options)

-- ---------- --
-- Visal mode --
-- ---------- --
vim.keymap.set('v', '<', '<gv', options)
vim.keymap.set('n', '>', '>gv', options)
