-- Git history and navigation
vim.api.nvim_set_keymap('n', '<leader>gg', ':GitMessenger<CR>',
    { noremap = true, silent = true, desc = "Show git commit message" })

-- File history and blame
vim.keymap.set('n', '<leader>gh', ':Gclog<CR>', { desc = 'View file history' })
vim.keymap.set('n', '<leader>gH', ':Gclog -p<CR>', { desc = 'Preview file history' })
vim.keymap.set('n', '<leader>gm', ':<C-U>Gclog -p -L <C-R>=expand("<cword>")<CR>:<C-R>=expand("%")<CR>:0<CR>', { desc = 'Show method history' })
vim.keymap.set('v', '<leader>gm', ":'<,'>Gclog -p<CR>", { desc = 'Show history for selection' })
vim.keymap.set('n', '<leader>gB', ':Git blame<CR>', { desc = 'Toggle git blame' })

-- Diff and conflict resolution
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit!<CR>", { desc = "Three way diff split" })  -- Three way split

-- Conflict resolution
vim.keymap.set("n", "<leader>gl", "2do", { desc = "Keep LOCAL version (Your changes)" })  -- Local
vim.keymap.set("n", "<leader>gr", "4do", { desc = "Keep REMOTE version (Their changes)" })  -- Remote
vim.keymap.set("n", "<leader>gB", "2do:diffget 4<CR>", { desc = "Keep BOTH changes (Local + Remote)" })  -- Both

-- Navigation through conflicts
vim.keymap.set("n", "<leader>gn", "]c", { desc = "Next Git conflict" })  -- Move to next conflict
vim.keymap.set("n", "<leader>gp", "[c", { desc = "Previous Git conflict" })  -- Move to previous conflict

-- View changes in current file
vim.keymap.set('n', '<leader>gs', ':Gdiffsplit<CR>', { desc = 'View file changes' })
