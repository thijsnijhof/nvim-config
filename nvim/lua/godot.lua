local M = {}
function M.root()
    local file = vim.api.nvim_buf_get_name(0)
    return vim.fs.root(file ~= '' and file or vim.fn.getcwd(), { 'project.godot' })
end
function M.command()
    for _, cmd in ipairs({ vim.env.GODOT_BIN or '', require('machine').godot.command or '', 'godot', 'godot4',
        '/Applications/Godot.app/Contents/MacOS/Godot' }) do
        if cmd ~= '' and vim.fn.executable(cmd) == 1 then return cmd end
    end
end
function M.server()
    local root = M.root()
    if not root then return end
    local socket = '/tmp/nvim-godot-' .. vim.fn.sha256(vim.fs.normalize(root)):sub(1, 16) .. '.sock'
    if vim.tbl_contains(vim.fn.serverlist(), socket) then return end
    local ok, err = pcall(vim.fn.serverstart, socket)
    if not ok then vim.notify('Godot editor bridge: ' .. tostring(err), vim.log.levels.WARN) end
end
function M.launch(editor, scene)
    local root, cmd = M.root(), M.command()
    if not root then vim.notify('No project.godot found.', vim.log.levels.WARN); return end
    if not cmd then vim.notify('Set GODOT_BIN to your Godot executable.', vim.log.levels.ERROR); return end
    local args = { cmd, '--path', root }
    if editor then args[#args + 1] = '--editor' end
    if scene then args[#args + 1] = '--scene'; args[#args + 1] = scene end
    vim.system(args, { text = true }, function(result)
        if result.code ~= 0 then vim.schedule(function()
            vim.notify('Godot exited: ' .. (result.stderr or ''), vim.log.levels.ERROR)
        end) end
    end)
end
function M.scene()
    local root = M.root()
    if not root then vim.notify('No project.godot found.', vim.log.levels.WARN); return end
    local files = vim.fn.globpath(root, '**/*.tscn', false, true)
    local scenes = {}
    for _, file in ipairs(files) do
        if not file:find('/.godot/', 1, true) then scenes[#scenes + 1] = file:sub(#root + 2) end
    end
    vim.ui.select(scenes, { prompt = 'Run Godot scene:' }, function(choice)
        if choice then M.launch(false, 'res://' .. choice) end
    end)
end
function M.setup()
    local group = vim.api.nvim_create_augroup('GodotBridge', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        group = group, pattern = { '*.gd', '*.tscn', '*.tres', 'project.godot' }, callback = M.server,
    })
    vim.keymap.set('n', '<leader>oge', function() M.launch(true) end, { desc = 'Godot: Open editor' })
    vim.keymap.set('n', '<leader>ogr', function() M.launch(false) end, { desc = 'Godot: Run project (saved files)' })
    vim.keymap.set('n', '<leader>ogs', M.scene, { desc = 'Godot: Choose scene to run' })
end
return M
