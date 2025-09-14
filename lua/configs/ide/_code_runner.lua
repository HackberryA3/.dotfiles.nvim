return {
	"CRAG666/code_runner.nvim",
	opts = {
		mode = "float",
		float = {
			border = "rounded",
		},
		focus = true,
		startinsert = true,
		-- TODO: 実行コマンドを言語ごとに設定する
		filetype = {
			cs = function()
				local root_dir = require("lspconfig").util.root_pattern "*.csproj" (vim.loop.cwd())
				vim.notify("C# root dir : " .. root_dir)
				return "cd " .. root_dir .. " && dotnet run$end"
			end,
			cpp = function()
				-- compile_flags.txt が見つかるまで親ディレクトリを探す
				local root_dir = require("lspconfig").util.root_pattern "compile_flags.txt" (vim.loop.cwd())
				vim.notify("C++ compile_flags root dir : " .. (root_dir or "nil"))

				-- compile_flags.txt が見つかった場合はその中身をコンパイルオプションとして利用する
				-- なければデフォルトのオプションを利用する
				-- -o オプションは必ずデフォルト値を利用する
				local compile_flags = root_dir and vim.fn.readfile(root_dir .. "/compile_flags.txt") or {}

				-- 読み込んだファイルに-oから始まる行があれば削除する
				-- 読み込んだファイルにパスが含まれている場合は絶対パスに変換する
				for i, flag in ipairs(compile_flags) do
					if flag:find("^-o") then
						table.remove(compile_flags, i)
						break
					end
					if flag:find("/") then
						-- flag から先頭のオプションを取得
						-- 例： -std=c++23 なら -std= を取得, -I../include なら -I を取得
						local option = flag:match("^%-%w+")
						-- flagからoptionを削除した部分がパス
						local path = flag:sub(#option + 1)
						-- root_dir からの相対パスを絶対パスに変換
						local absolute_path = vim.fn.fnamemodify(root_dir .. "/" .. path, ":p")
						compile_flags[i] = option .. absolute_path
						vim.notify("Converted compile flag path from " .. path .. " to " .. absolute_path)
					end
				end
				table.insert(compile_flags, "-o $fileNameWithoutExt")

				local compile_flags_str = table.concat(compile_flags, " ")
				vim.notify("C++ compile_flags : " .. compile_flags_str)


				return "cd $dir && g++ $fileName " .. compile_flags_str .. " && $dir/$fileNameWithoutExt"
			end,

			--[[ cpp = {
				"cd $dir &&",
				"g++ $fileName",
				"-std=c++23",
				"-o $fileNameWithoutExt &&",
				"$dir/$fileNameWithoutExt",
			}, ]]
			python = function()
				if vim.loop.os_uname().sysname == "Windows_NT" then
					return "python -u $fileName"
				else
					return "if (which python3 >/dev/null 2>&1); then python3 -u $fileName; else python -u $fileName; fi"
				end
			end,
			java = function()
				vim.notify("uname: " .. vim.inspect(vim.loop.os_uname()))
				if vim.loop.os_uname().sysname == "Linux" then
					return "cd $dir && java $fileName"
				else
					return "cd $dir && javac $fileName && java -cp $dir $fileNameWithoutExt"
				end
			end,
		}
	}
}
