vim.opt.clipboard = 'unnamedplus' -- system clipboard
vim.opt.completeopt = {'menu', 'menuone', 'noselect' }
vim.opt.mouse = 'a' -- allow mouse

-- Spacing
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true -- ignore case by default
vim.opt.smartcase = true -- case sensitive if uppercase
