local keyset = vim.keymap.set
local bufKeyset = vim.api.nvim_buf_set_keymap
local whichKey = require("which-key")
local map = function(desc) return { desc = desc, silent = true } end
local noremap = function(desc) return { desc = desc, silent = true, noremap = true } end
local exprMap = { expr = true, silent = true }
local exprNoremap = function(desc) return { desc = desc, silent = true, noremap = true, expr = true, replace_keycodes = false } end
local exprNoWait = { silent = true, nowait = true, expr = true }
local nowait = { silent = true, nowait = true }

return {
	setup = function()
		vim.g.mapleader = " " -- Lazyよりも前に設定する
		vim.g.maplocalleader = "\\"

		-- Insert Mode //////////////////////////////////////////////////////////////////////////////////
		keyset("i", "<C-j>", "<ESC>o", map("下の行に改行"))
		keyset("i", "<C-k>", "<ESC>O", map("上の行に改行"))
		keyset("i", "<A-j>", "<CMD>m .+1<CR>", map("下の行と入れ替え"))
		keyset("i", "<A-k>", "<CMD>m .-2<CR>", map("上の行と入れ替え"))

		keyset("i", "jj", "<ESC>", noremap("ノーマルモードに戻る"))
		-- //////////////////////////////////////////////////////////////////////////////////////////////
		-- Normal Mode //////////////////////////////////////////////////////////////////////////////////
		keyset("n", "j", "gj", noremap("下の行へ移動"))
		keyset("n", "k", "gk", noremap("上の行へ移動"))
		keyset("n", "gj", "j", noremap("下の行へ移動"))
		keyset("n", "gk", "k", noremap("上の行へ移動"))
		keyset("n", "<C-l>", "<CMD>bn<CR>", map("次のバッファに移動"))
		keyset("n", "<C-h>", "<CMD>bp<CR>", map("前のバッファに移動"))
		keyset("n", "<A-j>", "<CMD>m .+1<CR>==", map("下の行と入れ替え"))
		keyset("n", "<A-k>", "<CMD>m .-2<CR>==", map("上の行と入れ替え"))
		keyset("n", "<A-a>", "<ESC>ggVG", map("全選択"))

		whichKey.add({
			{ "<leader>w", proxy = "<c-w>", group = "Windows" },
		})

		keyset("n", "<TAB>", "za", noremap("折りたたみの切り替え"))
		whichKey.add({
			{ "z", group = "折りたたみ", icon = "󰕸" },
			{ "zR", "<CMD>lua require('ufo').openAllFolds()<CR>", desc = "全ての折りたたみを開く" },
			{ "zM", "<CMD>lua require('ufo').closeAllFolds()<CR>", desc = "全ての折りたたみを閉じる" },
		})
		-- //////////////////////////////////////////////////////////////////////////////////////////////
		-- Visual Mode //////////////////////////////////////////////////////////////////////////////////
		-- //////////////////////////////////////////////////////////////////////////////////////////////
		-- Terminal Mode ////////////////////////////////////////////////////////////////////////////////
		keyset("t", "<ESC>", [[<C-\><C-n><Plug>(esc)]], noremap("ノーマルモードに戻る"))
		keyset("n", "<Plug>(esc)<ESC>", "i<ESC>", noremap("ノーマルモードに戻る"))
		-- //////////////////////////////////////////////////////////////////////////////////////////////

		-- Filer ////////////////////////////////////////////////////////////////////////////////////////
		local nvimTreeFocusOrToggle = function()
			local nvimTree = require("nvim-tree.api")
			local currentBuf = vim.api.nvim_get_current_buf()
			local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
			if currentBufFt == "NvimTree" then
				nvimTree.tree.toggle()
			else
				nvimTree.tree.focus()
			end
		end
		whichKey.add({ { "<leader>e", nvimTreeFocusOrToggle, desc = "ファイラーを開く", icon = "󰉋" } })
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		-- Telescope ///////////////////////////////////////////////////////////////////////////////////
		local telescope_builtin = require('telescope.builtin')
		whichKey.add({
			{ "<leader>f", group = "色々検索", icon = "" },
			{ "<leader>ff", telescope_builtin.find_files, desc = "ファイルを検索", icon = "󰈔" },
			{ "<leader>fg", telescope_builtin.live_grep, desc = "grep検索", icon = "󰑑" },
			{ "<leader>fb", telescope_builtin.buffers, desc = "バッファを検索", icon = "󰈔" },
			{ "<leader>fh", telescope_builtin.help_tags, desc = "ヘルプを検索", icon = "󰋖" },
			{ "<leader>fc", telescope_builtin.commands, desc = "コマンドを検索", icon = "" },
			{ "<leader>fd", telescope_builtin.diagnostics, desc = "エラーや警告の一覧", icon = "" },
			{ "<leader>fo", telescope_builtin.treesitter, desc = "アウトラインを表示", icon = "" },
			{ "<leader>ft", "<CMD>TodoTelescope<CR>", desc = "TODOリストを表示", icon = "" },
		})
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		-- LSP /////////////////////////////////////////////////////////////////////////////////////////
		keyset("n", "<F12>", "<CMD>Lspsaga goto_definition<CR>")
		keyset("n", "<S-F12>", "<CMD>Lspsaga finder<CR>")
		keyset("n", "<F24>", "<CMD>Lspsaga finder<CR>")
		keyset("n", "<C-F12>", "<CMD>Lspsaga peek_definition<CR>")
		keyset("n", "<F36>", "<CMD>Lspsaga peek_definition<CR>")
		keyset("n", "K", "<CMD>Lspsaga hover_doc<CR>")
		keyset("n", "<F2>", "<CMD>Lspsaga rename<CR>")
		keyset("n", "<C-k><C-k>", "<CMD>Lspsaga code_action<CR>", noremap("コードアクション"))
		keyset("n", "[g", function() vim.diagnostic.jump({ count = -1, float = true }) end, noremap("前のエラーに移動"))
		keyset("n", "]g", function() vim.diagnostic.jump({ count = 1, float = true }) end, noremap("次のエラーに移動"))
		keyset("n", "<C-k><C-e>", function() vim.lsp.buf.format({ async = true }) end, noremap("フォーマット"))
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		-- DAP /////////////////////////////////////////////////////////////////////////////////////////
		local dap = require('dap')
		keyset('n', '<F5>', function() dap.continue() end)
		keyset('n', '<S-F5>', function() dap.terminate() end)
		keyset('n', '<F17>', function() dap.terminate() end)
		keyset('n', '<A-F5>', function() dap.run_last() end)
		keyset('n', '<F53>', function() dap.run_last() end)
		keyset('n', '<F10>', function() dap.step_over() end)
		keyset('n', '<F11>', function() dap.step_into() end)
		keyset('n', '<S-F11>', function() dap.step_out() end)
		keyset('n', '<F23>', function() dap.step_out() end)
		whichKey.add({
			{ "<leader>b", group = "ブレークポイント", icon = "󱀒" },
			{ "<leader>bb", function() dap.toggle_breakpoint() end, desc = "ブレークポイント" },
			{ "<leader>bl", function() dap.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "ログポイント", icon = "󱀓" },
			{ "<leader>bc", function() dap.toggle_breakpoint(vim.fn.input('Condition: '), nil, nil) end, desc = "条件付きブレークポイント", icon = "󰗋" },
			{ "<leader>bh", function() dap.toggle_breakpoint(nil, vim.fn.input('Hit count: '), nil) end, desc = "ヒットカウント", icon = "󰆙" },
			{ "<leader>bd", function() dap.clear_breakpoints() end, desc = "全てのブレークポイントを削除", icon = "󰆴" },
		})
		-- /////////////////////////////////////////////////////////////////////////////////////////////
		-- Code Runner /////////////////////////////////////////////////////////////////////////////////
		keyset("n", "<F4>", function() vim.cmd("RunCode") end)
		-- /////////////////////////////////////////////////////////////////////////////////////////////
		-- Test Runner ////////////////////////////////////////////////////////////////////////////////
		whichKey.add({
			{ "<leader>t", group = "テスト", icon = "" },
			{ "<leader>tt", function() require("neotest").summary.toggle() end, desc = "テストサマリーを表示" },
			{ "<leader>tn", function() require("neotest").run.run() end, desc = "テストを実行" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "ファイルのテストを実行" },
			{ "<leader>ts", function() require("neotest").run.stop() end, desc = "テストを停止" },
			{ "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "テスト出力を開く" },
			{ "<leader>tp", function() require("neotest").run.run({ suite = true }) end, desc = "スイートのテストを実行" },
			{ "<leader>tS", function() require("neotest").run.stop({ suite = true }) end, desc = "スイートのテストを停止" },
			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "テスト出力パネルを切り替え" },
		})

		-- Dial ////////////////////////////////////////////////////////////////////////////////////////
		keyset("n", "<C-a>", function()
			require("dial.map").manipulate("increment", "normal")
		end)
		keyset("n", "<C-x>", function()
			require("dial.map").manipulate("decrement", "normal")
		end)
		keyset("n", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gnormal")
		end)
		keyset("n", "g<C-x>", function()
			require("dial.map").manipulate("decrement", "gnormal")
		end)
		keyset("v", "<C-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end)
		keyset("v", "<C-x>", function()
			require("dial.map").manipulate("decrement", "visual")
		end)
		keyset("v", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gvisual")
		end)
		keyset("v", "g<C-x>", function()
			require("dial.map").manipulate("decrement", "gvisual")
		end)
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		-- HlsLens /////////////////////////////////////////////////////////////////////////////////////
		keyset('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			noremap("検索結果：次へ"))
		keyset('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			noremap("検索結果：前へ"))
		keyset('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], noremap("カーソル下の単語を下に検索"))
		keyset('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], noremap("カーソル下の単語を上に検索"))
		keyset('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], noremap("カーソル下の単語を下に検索"))
		keyset('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], noremap("カーソル下の単語を上に検索"))

		keyset('n', '<ESC>', '<ESC><Cmd>noh<CR>', noremap(""))
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		-- Hop /////////////////////////////////////////////////////////////////////////////////////////
		local hop = require('hop')
		local directions = require('hop.hint').HintDirection
		keyset("n", 'f', function()
			hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
		end, { remap = true })
		keyset("n", 'F', function()
			hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
		end, { remap = true })
		keyset("n", 't', function()
			hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
		end, { remap = true })
		keyset("n", 'T', function()
			hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
		end, { remap = true })

		keyset("n", "<leader>j", "<CMD>HopWord<CR>", noremap("単語ジャンプ"))
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		keyset("n", "<leader>m", "<CMD>Themery<CR>", noremap("テーマ切り替え"))
		keyset("n", "<leader>s", "<CMD>ISwapWith<CR>", noremap("スワップ"))

		whichKey.add({
			{ "<leader>g",  group = "Git" },
			{ "<leader>gg", "<CMD>LazyGit<CR>", desc = "LazyGit" }
		})
	end,

	set_githunk_keymap = function(bufnr)
		local git = require("gitsigns")
		-- Navigation
		bufKeyset(bufnr, 'n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", exprNoremap("次のGit変更"))
		bufKeyset(bufnr, 'n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", exprNoremap("前のGit変更"))

		-- Actions
		whichKey.add({
			{ "<leader>gs", git.stage_hunk, desc = "ハンクをステージング", buffer = bufnr, mode = { "n", "v" } },
			{ "<leader>gS", git.stage_buffer, desc = "ファイルをステージング", buffer = bufnr },
			{ "<leader>gu", git.undo_stage_hunk, desc = "ステージングをアンドゥ", buffer = bufnr },
			{ "<leader>gr", git.reset_hunk, desc = "ハンクをリセット", buffer = bufnr, mode = { "n", "v" } },
			{ "<leader>gR", git.reset_buffer, desc = "ファイルをリセット", buffer = bufnr },
			{ "<leader>gp", git.preview_hunk_inline, desc = "変更をプレビュー", buffer = bufnr },
			{ "<leader>gP", git.toggle_deleted, desc = "削除されたコードをプレビュー", buffer = bufnr },
			{ "<leader>gd", git.diffthis, desc = "差分を表示", buffer = bufnr },
			{ "<leader>gD", function() git.diffthis('~') end, desc = "差分を表示(HEAD~)", buffer = bufnr },
		})
	end,
}
