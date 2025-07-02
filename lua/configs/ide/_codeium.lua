return {
	"Exafunction/codeium.nvim",
	enabled = require("configs").ai.enable and require("configs").ai.use_codeium,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({})
	end
}
