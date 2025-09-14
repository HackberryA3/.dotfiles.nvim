return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		"marilari88/neotest-vitest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-vitest") {
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
					is_test_file = function(file_path)
						return file_path:match("%.test%.ts") or file_path:match("%.test%.js")
					end,
				}
			}
		})
	end,
}
