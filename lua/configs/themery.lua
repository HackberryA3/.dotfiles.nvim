return {
	themes = {
		{
			name = "Everforest Dark Hard",
			colorscheme = "everforest",
			before = [[
				vim.opt.background = "dark"
				vim.g.everforest_background = "hard"
				vim.g.everforest_better_performance = 1
				vim.g.everforest_diagnostic_text_highlight = 1
				vim.g.everforest_diagnostic_line_highlight = 1
				vim.g.everforest_diagnostic_virtual_text = "highlighted"
			]]
		},
		{
			name = "Kanagawa Wave",
			colorscheme = "kanagawa-wave",
		},
		{
			name = "Kanagawa Dragon",
			colorscheme = "kanagawa-dragon"
		},
		{
			name = "Catppuccin Frappe",
			colorscheme = "catppuccin-frappe"
		},
		{
			name = "Catppuccin Macchiato",
			colorscheme = "catppuccin-macchiato",
		},
		{
			name = "Catppuccin Mocha",
			colorscheme = "catppuccin-mocha"
		}
	},
	themeConfigFile = vim.fn.stdpath("config") .. "/lua/theme.lua",
	livePreview = true
}
