return {
  "jamestthompson3/nvim-docker",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  cmd = {
    "DockerContainers",
    "DockerImages",
    "DockerVolumes",
    "DockerNetworks",
    "DockerCompose",
  },
  config = function()
    local docker = require('docker')
    local actions = require('docker.actions')
    
    docker.setup({
      -- Default configuration
      default = {
        attach_shell = 'zsh',  -- You can change this to your preferred shell
        auto_refresh = true,   -- Auto-refresh containers, images, etc.
        auto_hide = true,      -- Auto-hide popup after selection
      },
      
      -- Keymaps configuration
      keymaps = {
        global = {
          -- Toggle the Docker window
          { '<leader>dd', '<cmd>DockerContainers<cr>', desc = 'Docker Containers' },
          { '<leader>di', '<cmd>DockerImages<cr>',     desc = 'Docker Images' },
          { '<leader>dv', '<cmd>DockerVolumes<cr>',    desc = 'Docker Volumes' },
          { '<leader>dn', '<cmd>DockerNetworks<cr>',   desc = 'Docker Networks' },
          { '<leader>dc', '<cmd>DockerCompose<cr>',    desc = 'Docker Compose' },
        },
        -- You can add more specific keymaps for different views
        containers = {
          { 'o', actions.select, { nowait = true } },
          { 'l', actions.select, { nowait = true } },
          { '<CR>', actions.select, { nowait = true } },
          { 's', actions.toggle_logs },
          { 'r', actions.restart_container },
          { 'S', actions.stop_container },
          { 'R', actions.remove_container },
        },
        images = {
          { 'r', actions.remove_image },
        },
      },
    })
  end,
}
