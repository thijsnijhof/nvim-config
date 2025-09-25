-- https://github.com/lewis6991/gitsigns.nvim

return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            current_line_blame = true, -- Enable blame by default
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 500, -- Reduced from 1000ms to 500ms
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                
                -- Toggle inline blame (in case you want to turn it off)
                vim.keymap.set('n', '<leader>gb', function()
                    gs.toggle_current_line_blame()
                end, { buffer = bufnr, desc = 'Toggle Git Blame' })
                
                -- Navigation between hunks
                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Next Git Hunk' })
                
                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Previous Git Hunk' })
            end,
        },
    },
}
