local M = {}

function M.setup()
    -- Configure PHP Actor for better performance
    vim.g.phpactorPhpBin = 'php'
    vim.g.phpactorBranch = 'master'
    vim.g.phpactorCompletionEnabled = 1
    vim.g.phpactorCompletionPriority = 1
    vim.g.phpactorCompletionAutoImport = 1
    
    -- Performance optimizations
    vim.g.phpactorUseRpc = 1  -- Use RPC for better performance
    vim.g.phpactorXdebugDisable = 1  -- Disable Xdebug for better performance
    vim.g.phpactorFileWatcher = 'inotify'  -- Use inotify for file watching
    
    -- Indexing configuration
    vim.g.phpactorIndexingExclude = {
        'vendor',
        'node_modules',
        'tests',
        'var',
        'cache',
        'build',
        'tmp',
    }
    
    -- Reference finding configuration
    vim.g.phpactorReferencesIgnoreHidden = 1
    vim.g.phpactorReferencesIgnoreVendors = 1
    vim.g.phpactorReferencesIgnoreTests = 1
    vim.g.phpactorReferencesIgnoreCache = 0
    
    -- LSP specific optimizations
    vim.g.phpactorLspEnabled = 1
    vim.g.phpactorLspHoverEnable = 1
    vim.g.phpactorLspRenameEnable = 1
    vim.g.phpactorLspFindReferencesEnable = 1
    vim.g.phpactorLspFindReferencesLimit = 100  -- Limit number of references to find
    
    -- Cache configuration
    vim.g.phpactorCacheDirectory = vim.fn.stdpath('cache') .. '/phpactor'
    vim.g.phpactorCacheEnabled = 1
    vim.g.phpactorCacheTtl = 3600  -- 1 hour cache TTL
    
    -- Disable unused features for better performance
    vim.g.phpactorCompletionImportUse = 0
    vim.g.phpactorCompletionImportClass = 0
    vim.g.phpactorCompletionImportFunction = 0
    vim.g.phpactorCompletionImportConstant = 0
    
    -- Configure the LSP client
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    lspconfig.phpactor.setup {
        on_attach = function(client, bufnr)
            -- You can add custom keymaps here if needed
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', '<leader>cf', function()
                -- Use a more efficient reference finding command
                vim.lsp.buf.references({
                    includeDeclaration = false,  -- Don't include declaration in references
                    bufnr = bufnr
                })
            end, vim.tbl_extend('force', bufopts, { desc = 'Find references (optimized)' }))
        end,
        capabilities = capabilities,
        cmd = { os.getenv('HOME') .. '/.composer/vendor/bin/phpactor', 'language-server' },
        init_options = {
            indexingEnabled = true,
            indexingPriority = 'memory',
            memoryLimit = '4G',
            maxMemory = '4G',
            cacheDirectory = vim.fn.stdpath('cache') .. '/phpactor',
            fileWatcher = 'inotify',
            completion = {
                enabled = true,
                priority = 1
            },
            references = {
                ignoreHidden = true,
                ignoreVendors = true,
                ignoreTests = true,
                limit = 100
            }
        },
        settings = {
            phpactor = {
                maxMemory = '4G',
                enableLanguageServer = true,
                languageServerLogLevel = 'info',
                completion = {
                    enabled = true,
                    priority = 1
                },
                indexing = {
                    enabled = true,
                    priority = 'memory',
                    exclude = {
                        'vendor',
                        'node_modules',
                        'tests',
                        'var',
                        'cache',
                        'build',
                        'tmp',
                    }
                },
                references = {
                    ignoreHidden = true,
                    ignoreVendors = true,
                    ignoreTests = true,
                    limit = 100
                }
            }
        }
    }
end

return M
