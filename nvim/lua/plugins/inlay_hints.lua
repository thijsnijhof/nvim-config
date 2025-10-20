-- Custom inlay hints that show on current line with delay
-- Uses NeoVim's built-in inlay hints (0.10+)

local ns = vim.api.nvim_create_namespace('inlay-hints')

local function clear_hints(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function render_hints(bufnr, hints)
    clear_hints(bufnr)
    
    for _, hint in ipairs(hints) do
        if hint and hint.position and hint.label then
            local line = hint.position.line
            local col = hint.position.character
            local label
            
            -- Handle different label formats
            if type(hint.label) == 'table' then
                if hint.label[1] and type(hint.label[1]) == 'string' then
                    -- Handle label parts format
                    local parts = {}
                    for _, part in ipairs(hint.label) do
                        if type(part) == 'string' then
                            table.insert(parts, part)
                        elseif type(part) == 'table' and part.value then
                            table.insert(parts, tostring(part.value))
                        end
                    end
                    label = table.concat(parts, '')
                else
                    -- Handle simple table format
                    label = ''
                    for k, v in pairs(hint.label) do
                        if type(v) == 'string' or type(v) == 'number' then
                            if label ~= '' then label = label .. ' ' end
                            label = label .. tostring(v)
                        end
                    end
                end
            else
                label = tostring(hint.label)
            end
            
            if label and label ~= '' then
                vim.api.nvim_buf_set_extmark(bufnr, ns, line, col, {
                    virt_text = {{ ' ' .. label:gsub('^%s+', ''), 'Comment' }},
                    virt_text_pos = 'eol',
                    hl_mode = 'combine',
                    priority = 0,
                })
            end
        end
    end
end

return {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function()
        -- This will be loaded after lspconfig
        vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
            buffer = 0,
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local params = {
                    textDocument = vim.lsp.util.make_text_document_params(),
                    range = {
                        start = { line = 0, character = 0 },
                        ['end'] = { line = vim.fn.line('$') - 1, character = 0 }
                    }
                }
                
                vim.lsp.buf_request(bufnr, 'textDocument/inlayHint', params, function(err, result, ctx)
                    if err then
                        vim.notify_once("Inlay hint error: " .. (err.message or "unknown error"), vim.log.levels.ERROR)
                        return
                    end
                    if not result or vim.tbl_isempty(result) then
                        clear_hints(bufnr)
                        return
                    end
                    render_hints(bufnr, result)
                end)
            end,
        })

        -- Clear hints when leaving the buffer
        vim.api.nvim_create_autocmd("BufLeave", {
            buffer = 0,
            callback = function()
                clear_hints(0)
            end,
        })
    end
}
