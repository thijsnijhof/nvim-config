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
  keys = {
    { "<leader>oca", "<cmd>AttachContainer<CR>", desc = "Container: Attach" },
    { "<leader>ocb", "<cmd>BuildImage<CR>", desc = "Container: Build image" },
    { "<leader>ocu", "<cmd>ComposeUp<CR>", desc = "Container: Compose up" },
    { "<leader>ocd", "<cmd>ComposeDown<CR>", desc = "Container: Compose down" },
    { "<leader>ocl", "<cmd>ComposeLogs<CR>", desc = "Container: Compose logs" },
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
