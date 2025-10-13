-- https://github.com/lvimuser/lsp-inlayhints.nvim
-- Shows inlay hints on the current line with a delay (like git blame)

return {
    "lvimuser/lsp-inlayhints.nvim",
    event = "LspAttach",
    config = function()
        require("lsp-inlayhints").setup({
            inlay_hints = {
                parameter_hints = {
                    show = true,
                    prefix = "← ",
                    separator = ", ",
                },
                type_hints = {
                    show = true,
                    prefix = "» ",
                    separator = ", ",
                },
                only_current_line = true,  -- Only show hints on current line
                labels_separator = " ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
            },
            enabled_at_startup = true,
            debug_mode = false,
        })
    end,
}
