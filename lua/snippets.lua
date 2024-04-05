local getSnipPath = function ()
	if vim.loop.os_uname().sysname == "Windows_NT" then
		return "~\\AppData\\Local\\nvim\\lua\\snippets"
	end
	return "~/.config/nvim/lua/snippets"
end

require("luasnip.loaders.from_lua").load({paths = getSnipPath()})
