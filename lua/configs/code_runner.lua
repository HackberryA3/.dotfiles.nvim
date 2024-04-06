return {
	mode = "term",
	focus = true,
	startinsert = true,
	filetype = {
		cs = function()
			local root_dir = require("lspconfig").util.root_pattern "*.csproj" (vim.loop.cwd())
			vim.notify("C# root dir : " .. root_dir)
			return "cd " .. root_dir .. " && dotnet run$end"
		end,
	}
}
