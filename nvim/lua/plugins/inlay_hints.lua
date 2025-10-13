-- Custom inlay hints that show on current line with delay
-- Uses NeoVim's built-in inlay hints (0.10+)

return {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function()
        -- This will be loaded after lspconfig
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                local params = vim.lsp.util.make_position_params()
                params.context = { includeDeclaration = true }
                vim.lsp.buf_request(0, "textDocument/inlayHint", params, function(err, result, ctx)
                    if err then
                        error(err)
                    end
                    if not result or not result.result then
                        return
                    end
                    local hints = {}
                    for _, hint in ipairs(result.result) do
                        if hint.placement then
                            table.insert(hints, hint)
                        end
                    end
                    vim.lsp.inlay_hint.render(hints, {})
                end)
            end,
        })
    end,
}
