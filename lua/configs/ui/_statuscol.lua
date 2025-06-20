return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local builtin = require("statuscol.builtin")
		require("statuscol").setup({
			relculright = true,
			ignore_ft = {
				"NvimTree",
				"dapui_scopes",
				"dapui_breakpoints",
				"dapui_stacks",
				"dapui_watches",
				"dap_repl",
				"dapui_console"
			},
			segments = {
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
				{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
				{ text = { " " }}
			},
		})
	end
}
