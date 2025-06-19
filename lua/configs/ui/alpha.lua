return{
	"goolord/alpha-nvim",
	config = function()
		require("alpha").setup(require("alpha.themes.theta").config)
	end,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim"
	}
}
