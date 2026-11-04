-- Native terminal agents. No model APIs or editor-specific AI plugins.
local M = {}
local config = require('ai_config')
local commands = config.agents
local provider = vim.env.DEV_AI_AGENT or config.default

local function tmux(args)
    local result = vim.system(vim.list_extend({ 'tmux' }, args), { text = true }):wait()
    if result.code ~= 0 then
        error(vim.trim(result.stderr or 'tmux command failed'))
    end
    return vim.trim(result.stdout or '')
end

function M.open()
    if not vim.env.TMUX or not vim.env.TMUX_PANE then
        vim.notify('Start Neovim inside tmux to open an agent pane.', vim.log.levels.WARN)
        return
    end
    if not commands[provider] then
        vim.notify('Unknown agent: ' .. tostring(provider) .. '. Configure it in lua/ai_config.lua.', vim.log.levels.ERROR)
        return
    end
    local ok, err = pcall(function()
        local window = tmux({ 'display-message', '-p', '-t', vim.env.TMUX_PANE, '#{window_id}' })
        local panes = tmux({ 'list-panes', '-t', window, '-F', '#{pane_id}\t#{@dev_ai_agent}\t#{pane_dead}' })
        for line in panes:gmatch('[^\n]+') do
            local pane, agent, dead = line:match('^(%%%d+)\t([^\t]*)\t(%d)$')
            if agent == provider and dead == '0' then
                tmux({ 'select-pane', '-t', pane })
                return
            end
        end
        local command = commands[provider]
        if type(command) ~= 'table' or #command == 0 then error('Agent command must be a nonempty argument list.') end
        for _, arg in ipairs(command) do
            if type(arg) ~= 'string' then error('Agent arguments must be strings.') end
        end
        if vim.fn.executable(command[1]) ~= 1 then
            error(command[1] .. ' is not on PATH. Install/sign in to this agent first.')
        end
        -- Anchor to the editor pane's working directory, matching terminal use.
        local cwd = tmux({ 'display-message', '-p', '-t', vim.env.TMUX_PANE, '#{pane_current_path}' })
        local args = { 'split-window', '-h', '-p', '40', '-t', vim.env.TMUX_PANE,
            '-c', cwd, '-P', '-F', '#{pane_id}' }
        -- A single tmux command is interpreted by a shell: quote every argument.
        local quoted = {}
        for _, arg in ipairs(command) do quoted[#quoted + 1] = vim.fn.shellescape(arg) end
        args[#args + 1] = table.concat(quoted, ' ')
        local pane = tmux(args)
        tmux({ 'set-option', '-p', '-t', pane, '@dev_ai_agent', provider })
    end)
    if not ok then vim.notify(tostring(err), vim.log.levels.ERROR) end
end

function M.choose()
    vim.ui.select(vim.tbl_keys(commands), { prompt = 'Agent for this Neovim session:' }, function(choice)
        if choice then
            provider = choice
            vim.notify('Agent: ' .. choice .. '. Existing agent panes are preserved.')
        end
    end)
end

local function copy(text)
    local ok, err = pcall(vim.fn.setreg, '+', text)
    if ok then
        vim.notify('Context copied. Open the agent with Space ii, then paste and review.')
    else
        vim.notify('Clipboard unavailable: ' .. tostring(err), vim.log.levels.ERROR)
    end
end

local function file_label()
    local path = vim.api.nvim_buf_get_name(0)
    return path ~= '' and path or '[unnamed buffer]'
end

function M.file()
    copy(file_label() .. ':' .. vim.api.nvim_win_get_cursor(0)[1])
end

function M.selection()
    -- Capture current visual endpoints, including reversed and block selections.
    local mode = vim.fn.mode()
    local anchor, cursor = vim.fn.getpos('v'), vim.fn.getpos('.')
    local lines = vim.fn.getregion(anchor, cursor, {
        type = mode, exclusive = vim.o.selection == 'exclusive',
    })
    copy(('%s:%d-%d\n```%s\n%s\n```'):format(file_label(),
        math.min(anchor[2], cursor[2]), math.max(anchor[2], cursor[2]),
        vim.bo.filetype, table.concat(lines, '\n')))
end

function M.diagnostics()
    local lines = { 'Diagnostics for ' .. file_label() }
    for _, d in ipairs(vim.diagnostic.get(0)) do
        lines[#lines + 1] = ('%d:%d [%s] %s'):format(d.lnum + 1,
            d.col + 1, vim.diagnostic.severity[d.severity] or 'UNKNOWN', d.message)
    end
    if #lines == 1 then lines[#lines + 1] = 'No diagnostics reported.' end
    copy(table.concat(lines, '\n'))
end

function M.setup()
    vim.keymap.set('n', '<leader>ii', M.open, { desc = 'AI: Open/focus agent pane' })
    vim.keymap.set('n', '<leader>ip', M.choose, { desc = 'AI: Choose provider' })
    vim.keymap.set('n', '<leader>if', M.file, { desc = 'AI: Copy file and line' })
    vim.keymap.set('x', '<leader>is', M.selection, { desc = 'AI: Copy selection' })
    vim.keymap.set('n', '<leader>id', M.diagnostics, { desc = 'AI: Copy buffer diagnostics' })
end

return M
