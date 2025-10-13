return {
  "jamestthompson3/nvim-remote-containers",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap"  -- For debugging in containers
  },
  cmd = {
    "AttachContainer",
    "BuildImage",
    "Compose",
    "ComposeUp",
    "ComposeDown",
    "ComposeLogs",
  },
  config = function()
    -- Define keymaps first to avoid conflicts
    local keymap = vim.keymap
    local opts = { silent = true, noremap = true }
    
    -- Set up the plugin
    require('remote-containers').setup({
      -- Default configuration
      attach_mounts = {
        vim = true,  -- Mount the local Neovim config
        nvim = true, -- Mount the local Neovim config (for nvim 0.9+)
      },
    })
    
    -- Function key mappings for Docker
    keymap.set('n', '<F6>', ':AttachContainer<CR>', vim.tbl_extend('force', opts, { desc = 'Attach to container' }))
    keymap.set('n', '<F7>', ':BuildImage<CR>', vim.tbl_extend('force', opts, { desc = 'Build container image' }))
    keymap.set('n', '<F8>', ':ComposeUp<CR>', vim.tbl_extend('force', opts, { desc = 'Docker Compose Up' }))
    keymap.set('n', '<F9>', ':ComposeDown<CR>', vim.tbl_extend('force', opts, { desc = 'Docker Compose Down' }))
    keymap.set('n', '<F10>', ':ComposeLogs<CR>', vim.tbl_extend('force', opts, { desc = 'Docker Compose Logs' }))
    
    -- Buffer-local keymaps for container actions
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'DockerContainer',
      callback = function()
        local buf_opts = { buffer = true, silent = true, noremap = true }
        keymap.set('n', 'o', ':lua require("remote-containers").open()<CR>', buf_opts)
        keymap.set('n', 's', ':lua require("remote-containers").start()<CR>', buf_opts)
        keymap.set('n', 'S', ':lua require("remote-containers").stop()<CR>', buf_opts)
        keymap.set('n', 'r', ':lua require("remote-containers").restart()<CR>', buf_opts)
        keymap.set('n', 'l', ':lua require("remote-containers").logs()<CR>', buf_opts)
      end,
    })
  end,
}
