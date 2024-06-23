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
		-- //////////////////////////////////////////////////////////////////////////////////////////////
		-- Normal Mode //////////////////////////////////////////////////////////////////////////////////
		keyset("n", "<A-l>", "<CMD>bn<CR>", map("次のバッファに移動"))
		keyset("n", "<A-h>", "<CMD>bp<CR>", map("前のバッファに移動"))
		keyset("n", "<A-j>", "<CMD>m .+1<CR>==", map("下の行と入れ替え"))
		keyset("n", "<A-k>", "<CMD>m .-2<CR>==", map("上の行と入れ替え"))
		keyset("n", "<A-a>", "<ESC>ggVG", map("全選択"))
		-- //////////////////////////////////////////////////////////////////////////////////////////////
		-- Visual Mode //////////////////////////////////////////////////////////////////////////////////
		-- //////////////////////////////////////////////////////////////////////////////////////////////
		-- Terminal Mode ////////////////////////////////////////////////////////////////////////////////
		keyset("t", "<ESC>", [[<C-\><C-n>]], noremap("ノーマルモードに戻る"))
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
		keyset("n", "<space>e", nvimTreeFocusOrToggle, noremap("ファイラーを開く"))
		-- /////////////////////////////////////////////////////////////////////////////////////////////

		-- Telescope ///////////////////////////////////////////////////////////////////////////////////
		local telescope_builtin = require('telescope.builtin')
		whichKey.register({
			["<leader>f"] = {
				name = "テレスコープ",
				f = { telescope_builtin.find_files, "ファイルを検索" },
				g = { telescope_builtin.live_grep, "grep検索" },
				b = { telescope_builtin.buffers, "バッファを検索" },
				h = { telescope_builtin.help_tags, "ヘルプを検索" },
				c = { telescope_builtin.commands, "コマンドを検索" },
			}
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
		keyset("n", "[g", vim.diagnostic.goto_prev, noremap("前のエラーに移動"))
		keyset("n", "]g", vim.diagnostic.goto_next, noremap("次のエラーに移動"))
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
		whichKey.register({
			["<leader>b"] = {
				name = "ブレークポイント",
				b = { function() dap.toggle_breakpoint() end, "ブレークポイント" },
				l = { function() dap.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, "ログポイント" },
				c = { function() dap.toggle_breakpoint(vim.fn.input('Condition: '), nil, nil) end, "条件付きブレークポイント" },
				h = { function() dap.toggle_breakpoint(nil, vim.fn.input('Hit count: '), nil) end, "ヒットカウント" },
				d = { function() dap.clear_breakpoints() end, "全てのブレークポイントを削除" },
			}
		})
		-- /////////////////////////////////////////////////////////////////////////////////////////////
		-- Code Runner /////////////////////////////////////////////////////////////////////////////////
		keyset("n", "<F4>", function() vim.cmd("RunCode") end)
		-- /////////////////////////////////////////////////////////////////////////////////////////////

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
		keyset('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], noremap("検索結果：次へ"))
		keyset('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], noremap("検索結果：前へ"))
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

		keyset("n", "<leader>t", "<CMD>Themery<CR>", noremap("テーマ切り替え"))
		keyset("n", "<leader>s", "<CMD>ISwapWith<CR>", noremap("スワップ"))

		whichKey.register({
			["<leader>g"] = {
				g = { "<CMD>LazyGit<CR>", "Git GUI" },
			}
		})
	end,

	set_githunk_keymap = function(bufnr)
		local git = require("gitsigns")
		-- Navigation
		bufKeyset(bufnr, 'n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", exprNoremap("次のGit変更"))
		bufKeyset(bufnr, 'n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", exprNoremap("前のGit変更"))

		-- Actions
		whichKey.register({
			["<leader>g"] = {
				name = "Git",
				s = { git.stage_hunk, "ハンクをステージング", buffer = bufnr, mode = { "n", "v" } },
				S = { git.stage_buffer, "ファイルをステージング", buffer = bufnr },
				u = { git.undo_stage_hunk, "ステージングをアンドゥ", buffer = bufnr },
				r = { git.reset_hunk, "ハンクをリセット", buffer = bufnr, mode = { "n", "v" } },
				R = { git.reset_buffer, "ファイルをリセット", buffer = bufnr },
				p = { git.preview_hunk_inline, "変更をプレビュー", buffer = bufnr },
				P = { git.toggle_deleted, "削除されたコードをプレビュー", buffer = bufnr },
				d = { git.diffthis, "差分を表示", buffer = bufnr },
				D = { function() git.diffthis('~') end, "差分を表示(HEAD~)", buffer = bufnr },
			}
		})
	end,
}
