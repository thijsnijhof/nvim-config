local function compare_branch()
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fs.root(file ~= '' and file or vim.fn.getcwd(), { '.git' })
    if not cwd then vim.notify('Not inside a Git repository.', vim.log.levels.WARN); return end
    vim.ui.input({ prompt = 'Compare branch changes since merge-base with ref: ' }, function(ref)
        if not ref or vim.trim(ref) == '' then return end
        ref = vim.trim(ref)
        if ref:match('^%-') then vim.notify('Enter a branch, tag, or commit.', vim.log.levels.ERROR); return end
        local result = vim.system({ 'git', '-C', cwd, 'merge-base', 'HEAD', ref }, { text = true }):wait()
        if result.code ~= 0 then
            vim.notify('Cannot find merge-base: ' .. vim.trim(result.stderr or ''), vim.log.levels.ERROR)
            return
        end
        local base = vim.trim(result.stdout)
        if not base:match('^%x+$') then return end
        vim.cmd({ cmd = 'DiffviewOpen', args = { '-C' .. cwd, base .. '..HEAD' } })
    end)
end
return {
    'sindrets/diffview.nvim',
    commit = '4516612fe98ff56ae0415a259ff6361a89419b0a',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewRefresh' },
    opts = {
        enhanced_diff_hl = true,
        file_panel = { listing_style = 'tree', win_config = { position = 'left', width = 35 } },
    },
    keys = {
        { '<leader>gv', '<cmd>DiffviewOpen<CR>', desc = 'Git: Review all uncommitted changes' },
        { '<leader>gV', compare_branch, desc = 'Git: Compare branch from chosen merge-base' },
        { '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', desc = 'Git: Visual file history' },
        { '<leader>gF', '<cmd>DiffviewFileHistory<CR>', desc = 'Git: Visual repository history' },
        { '<leader>gq', '<cmd>DiffviewClose<CR>', desc = 'Git: Close diff viewer' },
    },
}
