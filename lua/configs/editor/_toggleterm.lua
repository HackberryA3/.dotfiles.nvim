return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		open_mapping = [[<C-\>]],
		shell = function()
			if vim.loop.os_uname().sysname == "Windows_NT" then
				return "pwsh"
			end
			return vim.o.shell
		end,
		autochdir = true,
		direction = "float",
		float_opts = {
			border = "rounded",
		}
	}
}
