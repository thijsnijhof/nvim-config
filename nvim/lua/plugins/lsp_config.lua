-- https://github.com/neovim/nvim-lspconfig

local M = {}

function M.setup()
    -- Ensure mason is loaded
    local mason_ok, _ = pcall(require, 'mason')
    if not mason_ok then
        vim.notify('Mason not found. Please install it first.', vim.log.levels.ERROR)
        return
    end

    -- Configure mason
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "ts_ls",
            "pyright",
            "jsonls",
            "sqlls",
            "yamlls"
        },
        automatic_installation = true,
    })

    -- Initialize inlay hints
    local inlay_hint = vim.lsp.inlay_hint

    local on_attach = function(client, bufnr)
        -- Set up position encoding
        client.offset_encoding = client.offset_encoding or 'utf-16'

        -- Enable inlay hints if available
        if inlay_hint then
            inlay_hint.enable(true, { bufnr = bufnr })
        end

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
                    return c.name ~= 'ts_ls' and c.name ~= 'lua_ls'
                end,
            })
        end, vim.tbl_extend("force", opts, { desc = "Format document" }))

        -- Toggle inlay hints
        if inlay_hint and client.supports_method('textDocument/inlayHint') then
            keymap('n', 'yh', function()
                inlay_hint.enable(not inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                vim.notify('Inlay hints ' .. (inlay_hint.is_enabled({ bufnr = bufnr }) and 'enabled' or 'disabled'))
            end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
        end
    end

    -- Set up capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Set up LspAttach autocommand for keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                on_attach(client, args.buf)
            end
        end,
    })

    -- Configure servers using vim.lsp.config (Neovim 0.11+)
    vim.lsp.config('ts_ls', {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx"
        },
        root_dir = function(bufnr, on_dir)
            -- Find nearest tsconfig.json to the buffer file (supports monorepos/project references)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local nearest_tsconfig = vim.fs.find('tsconfig.json', {
                path = vim.fs.dirname(fname),
                upward = true,
            })[1]
            if nearest_tsconfig then
                on_dir(vim.fs.dirname(nearest_tsconfig))
            else
                -- Fallback to package.json
                local pkg = vim.fs.find('package.json', {
                    path = vim.fs.dirname(fname),
                    upward = true,
                })[1]
                if pkg then
                    on_dir(vim.fs.dirname(pkg))
                end
            end
        end,
        capabilities = capabilities,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
            }
        },
    })

    vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
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
    })

    vim.lsp.config('pyright', {
        capabilities = capabilities,
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'pyrightconfig.json' },
    })

    vim.lsp.config('jsonls', {
        capabilities = capabilities,
        root_markers = { '.git' },
    })

    vim.lsp.config('sqlls', {
        capabilities = capabilities,
        root_markers = { '.git' },
    })

    vim.lsp.config('yamlls', {
        capabilities = capabilities,
        root_markers = { '.git' },
    })

    -- Enable all configured servers
    vim.lsp.enable({ 'ts_ls', 'lua_ls', 'pyright', 'jsonls', 'sqlls', 'yamlls' })

    vim.notify('LSP configuration loaded successfully')
end

return M
