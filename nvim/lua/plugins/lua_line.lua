return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            theme = {
                normal = {
                    a = { fg = '#190f28', bg = '#ff4fbc', gui = 'bold' },
                    b = { fg = '#e5d9f2', bg = '#452454' },
                    c = { fg = '#a58bb8', bg = '#231535' },
                },
                insert = { a = { fg = '#190f28', bg = '#36e5da', gui = 'bold' } },
                visual = { a = { fg = '#190f28', bg = '#bd93f9', gui = 'bold' } },
                replace = { a = { fg = '#190f28', bg = '#ff6b91', gui = 'bold' } },
                command = { a = { fg = '#190f28', bg = '#ffc66d', gui = 'bold' } },
                inactive = {
                    a = { fg = '#a58bb8', bg = '#231535' },
                    b = { fg = '#a58bb8', bg = '#231535' },
                    c = { fg = '#a58bb8', bg = '#231535' },
                },
            },
            icons_enabled = true,
            component_separators = '|',
            section_separators = '',
        },
    },
}
