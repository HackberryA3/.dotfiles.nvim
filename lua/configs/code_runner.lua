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
		python = function()
			if vim.loop.os_uname().sysname == "Windows_NT" then
				return "python -u $fileName"
			else
				return "if (which python3 >/dev/null 2>&1); then python3 -u $fileName; else python -u $fileName; fi"
			end
		end,
	}
}
