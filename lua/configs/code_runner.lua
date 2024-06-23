return {
	mode = "float",
	float = {
		border = "rounded",
	},
	focus = true,
	startinsert = true,
	filetype = {
		cs = function()
			local root_dir = require("lspconfig").util.root_pattern "*.csproj" (vim.loop.cwd())
			vim.notify("C# root dir : " .. root_dir)
			return "cd " .. root_dir .. " && dotnet run$end"
		end,
		cpp = {
			"cd $dir &&",
			"g++ $fileName",
			"-std=c++23",
			"-o $fileNameWithoutExt &&",
			"$dir/$fileNameWithoutExt",
		},
	}
}
