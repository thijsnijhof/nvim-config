return {
	{
	 "xiantang/darcula-dark.nvim",
		config = function()
			-- setup must be called before loading
			require("darcula").setup({})
		end,
		opts = function()
			vim.cmd.colorscheme('darcula')
		end,	
	},
}
