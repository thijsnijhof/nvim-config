return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>fr",
            function()
                local conform = require("conform")
                local available = conform.list_formatters(0)
                if not vim.iter(available):any(function(f) return f.available end) then
                    vim.notify("No formatter available. See :ConformInfo and README.md.", vim.log.levels.WARN)
                    return
                end
                conform.format({ async = true, lsp_format = "never" })
            end,
            desc = "Format document",
        },
    },
    opts = {
        formatters_by_ft = {
            gdscript = { "gdformat" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            lua = { "stylua" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            php = { "php_cs_fixer" },
        },
        formatters = {
            gdformat = {
                command = function()
                    return require('machine').formatting.gdformat
                end,
            },
            php_cs_fixer = {
                -- Avoid creating a PHP-CS-Fixer cache file in the project.
                prepend_args = { "--using-cache=no" },
            },
        },
        -- Formatting is manual: no BufWritePre hook or format-on-save.
    },
}
