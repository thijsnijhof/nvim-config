-- Move through Neovim splits first, then cross the tmux pane boundary.
local M = {}
local directions = { h = 'L', j = 'D', k = 'U', l = 'R' }
function M.move(key)
    local before = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    if vim.api.nvim_get_current_win() ~= before or not vim.env.TMUX or not vim.env.TMUX_PANE then
        return
    end
    if vim.fn.executable('tmux') ~= 1 then return end
    local result = vim.system({ 'tmux', 'select-pane', '-t', vim.env.TMUX_PANE,
        '-' .. directions[key] }, { text = true }):wait()
    if result.code ~= 0 then
        vim.notify(vim.trim(result.stderr or 'tmux navigation failed'), vim.log.levels.WARN)
    end
end
function M.setup()
    local labels = { h = 'left', j = 'down', k = 'up', l = 'right' }
    for key, label in pairs(labels) do
        vim.keymap.set('n', '<C-' .. key .. '>', function() M.move(key) end,
            { desc = 'Navigate ' .. label .. ' across Neovim/tmux' })
    end
end
return M
