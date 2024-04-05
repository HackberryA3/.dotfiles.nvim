return {
	open_mapping = [[<C-\>]],
	shell = function()
		if vim.loop.os_uname().sysname == "Windows_NT" then
			return "pwsh"
		end
		return vim.o.shell
	end,
	autochdir = true
}
