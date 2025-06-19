return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		transparent_background = true,
		integrations = {
			fern = true,
			fidget = true,
			lsp_saga = true,
			mason = true,
			mini = true,
			noice = true,
			notify = true,
			telescope = {
				enabled = true
			}
		}
	}
}
