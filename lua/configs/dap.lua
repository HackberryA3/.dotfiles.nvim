-- MasonでインストールしたDAPを設定する
require("mason-nvim-dap").setup({
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
			vim.notify("Load dap : " .. config.name, "info", { title = "Mason" })
			vim.print(config)
		end
	}
})



-- デバッグ構成の設定
local dap, dapui = require("dap"), require("dapui")
table.insert(dap.configurations.cpp,
	{
		name = "Debug this file",
		type = "codelldb",
		request = "launch",
		program = function()
			local filePath = vim.api.nvim_buf_get_name(0)
			-- 拡張子なしのファイル名を取得
			local fileName = filePath:match("([^/]+)$"):match("(.+)%..+")
			local ext = vim.fn.has("win32") == 1 and ".exe" or ".out"

			os.execute("g++ -g " .. filePath .. " -o " .. fileName .. ext)
			vim.notify("Compiled : " .. filePath, "info", { title = "DAP" })

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
