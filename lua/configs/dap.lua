local level = vim.log.levels

-- MasonでインストールしたDAPを設定する
local loaded_dap = {}
require("mason-nvim-dap").setup({
	ensure_installed = {
		"codelldb",
		"coreclr",
		"javadbg",
		"python"
	},
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
			table.insert(loaded_dap, config.name)
			-- vim.print(config)
		end
	}
})
if #loaded_dap ~= 0 then
	vim.notify("Loaded DAP\n  " .. table.concat(loaded_dap, "\n  "), level.INFO, { title = "Mason" })
end


-- デバッグ構成の設定
local dap, dapui = require("dap"), require("dapui")
if dap.configurations.cpp == nil then
	dap.configurations.cpp = {}
end
table.insert(dap.configurations.cpp,
	{
		name = "Debug this file",
		type = "codelldb",
		request = "launch",
		program = function()
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

			local filePath = vim.api.nvim_buf_get_name(0)
			-- 拡張子なしのファイル名を取得
			local fileName = filePath:match("(.+)%..+$")
			local ext = vim.fn.has("win32") == 1 and ".exe" or ""
			table.insert(compile_flags, "-o " .. fileName .. ext)

			local compile_flags_str = table.concat(compile_flags, " ")
			vim.notify("C++ compile_flags : " .. compile_flags_str)




			os.execute("g++ -g " .. filePath .. " " .. compile_flags_str)
			vim.notify("Compiled : " .. filePath .. "\n" .. "To : " .. fileName .. ext, level.INFO, { title = "DAP" })

			return fileName .. ext
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = false,
		args = {},
	}
)



-- デバッグが始まると自動でUIを開く
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end



-- ブレークポイントの見た目
vim.fn.sign_define('DapBreakpoint', { text = '󱀒', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '󱀓', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '󰗋', texthl = 'DapLogPoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '󰋇', texthl = 'DapStopped', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '󰖝', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })
