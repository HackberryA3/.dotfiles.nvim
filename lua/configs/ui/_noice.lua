return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	opts = {
		views = {
			progress = {
				backend = "notify",
				fallback = "mini",
				format = "notify",
				replace = true,
				merge = true,
			},
			mini = {
				position = {
					row = -2
				}
			}
		},
		popupmenu = {
			enabled = false,
		},
		messages = {
			enabled = false,
		},
		lsp = {
			progress = {
				enabled = true,
				view = "progress"
			},
			hover = {
				enabled = false,
			},
			signature = {
				enabled = false,
			},
			message = {
				enabled = true,
			},
		}
	}
}
