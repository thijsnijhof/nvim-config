-- https://github.com/neovim/nvim-lspconfig

local M = {}

function M.setup()
    -- Ensure plugins are loaded
    local ok, lspconfig = pcall(require, 'lspconfig')
    if not ok then
        vim.notify('Failed to load nvim-lspconfig', vim.log.levels.ERROR)
        return
    end
    
    -- Ensure mason is loaded
    local mason_ok, _ = pcall(require, 'mason')
    if not mason_ok then
        vim.notify('Mason not found. Please install it first.', vim.log.levels.ERROR)
        return
    end
    
    -- Configure mason
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver", "pyright", "jsonls", "sqlls", "yamlls" },
        automatic_installation = false,
    })
    
    -- Initialize inlay hints
    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
    
    local on_attach = function(client, bufnr)
        -- Set up position encoding
        client.offset_encoding = client.offset_encoding or 'utf-16'
        
        -- Set up keymaps
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local keymap = vim.keymap.set
        
        -- Navigation
        keymap('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        keymap('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        keymap('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        keymap('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Show signature help" }))
        
        -- Workspace
        keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        keymap('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
        
        -- Code actions
        keymap('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
        keymap('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        keymap('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
        
        -- Enhanced references with quickfix list
        keymap('n', 'gr', function()
            vim.lsp.buf.references(nil, {
                on_list = function(options)
                    vim.fn.setqflist({}, ' ', options)
                    vim.cmd('copen')
                end
            })
        end, vim.tbl_extend("force", opts, { desc = "References" }))
        
        -- Formatting with better options
        keymap('n', '<leader>fr', function() 
            vim.lsp.buf.format({
                async = true,
                timeout_ms = 5000,
                name = client.name,
                filter = function(c)
                    return c.name ~= 'tsserver' and c.name ~= 'lua_ls'
                end,
            }) 
        end, vim.tbl_extend("force", opts, { desc = "Format document" }))

        -- Toggle inlay hints
        if inlay_hint and client.supports_method('textDocument/inlayHint') then
            keymap('n', 'yh', function()
                inlay_hint.enable(bufnr, not inlay_hint.is_enabled(bufnr))
                vim.notify('Inlay hints ' .. (inlay_hint.is_enabled(bufnr) and 'enabled' or 'disabled'))
            end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
        end
    end

    -- Set up capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Configure servers
    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false
                    },
                    telemetry = { enable = false }
                }
            }
        },
        tsserver = {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    }
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    }
                }
            }
        },
        pyright = {},
        jsonls = {},
        sqlls = {},
        yamlls = {}
    }

    -- Setup each server
    for server, config in pairs(servers) do
        config.on_attach = on_attach
        config.capabilities = capabilities
        
        -- Use the new API to set up the server
        local ok, server_config = pcall(require, 'lspconfig.server_configurations.' .. server)
        if ok then
            server_config.setup(config)
        else
            lspconfig[server].setup(config)
        end
    end
    
    vim.notify('LSP configuration loaded successfully')
end

return M
