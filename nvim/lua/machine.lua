-- Shared defaults plus one machine-local override outside the checkout.
local defaults = {
    ai = { default = 'codex', agents = { codex = { 'codex' }, kiro = { 'kiro-cli', 'chat' } } },
    acp = { provider = 'codex-acp', providers = {} },
    godot = { command = nil },
    formatting = { gdformat = 'gdformat' },
}
local path = vim.fn.fnamemodify(vim.fn.stdpath('config'), ':h') .. '/dev-setup.local.lua'
if vim.fn.filereadable(path) == 1 then
    local ok, config = pcall(dofile, path)
    if not ok or type(config) ~= 'table' then
        vim.notify('Invalid machine settings: ' .. path .. ': ' .. tostring(config), vim.log.levels.ERROR)
    else
        defaults = vim.tbl_deep_extend('force', defaults, config)
    end
end
return defaults
