return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons"
	},
	opts = {
		code_action = {
			keys = {
				quit = { "q", "<ESC>" }
			}
		},
		definition = {
			keys = {
				quit = { "q", "<ESC>" }
			}
		},
		finder = {
			keys = {
				quit = { "q", "<ESC>" }
			}
		},
		lightbulb = {
			sign = false
		},
		rename = {
			in_select = false,
			keys = {
				quit = { "<ESC>" }
			}
		},
	}
}
