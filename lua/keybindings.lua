local keyset = vim.keymap.set
local map = { silent = true }
local noremap = { silent = true, noremap = true }
local exprMap = { expr = true, silent = true }
local exprNoremap = { silent = true, noremap = true, expr = true, replace_keycodes = false }
local exprNoWait = { silent = true, nowait = true, expr = true }
local nowait = { silent = true, nowait = true }

vim.g.mapleader = " " -- Lazyよりも前に設定する
vim.g.maplocalleader = "\\"

-- Insert Mode //////////////////////////////////////////////////////////////////////////////////
keyset("i", "<C-j>", "<ESC>o", map)             -- Ctrl + j で次の行に改行
keyset("i", "<C-k>", "<ESC>O", map)             -- Ctrl + k で上の行に改行
keyset("n", "<A-j>", "<CMD>m .+1<CR>==gi", map) -- Alt + j で下の行と入れ替え
keyset("n", "<A-k>", "<CMD>m .-2<CR>==gi", map) -- Alt + k で上の行と入れ替え
-- //////////////////////////////////////////////////////////////////////////////////////////////
-- Normal Mode //////////////////////////////////////////////////////////////////////////////////
keyset("n", "<A-l>", "<CMD>bn<CR>", map)      -- Alt + l で次のバッファに移動
keyset("n", "<A-h>", "<CMD>bp<CR>", map)      -- Alt + h で前のバッファに移動
keyset("n", "<A-j>", "<CMD>m .+1<CR>==", map) -- Alt + j で下の行と入れ替え
keyset("n", "<A-k>", "<CMD>m .-2<CR>==", map) -- Alt + k で上の行と入れ替え
-- //////////////////////////////////////////////////////////////////////////////////////////////
-- Visual Mode //////////////////////////////////////////////////////////////////////////////////
-- //////////////////////////////////////////////////////////////////////////////////////////////
-- Terminal Mode ////////////////////////////////////////////////////////////////////////////////
keyset("t", "<ESC>", [[<C-\><C-n>]], noremap)
-- //////////////////////////////////////////////////////////////////////////////////////////////

-- Fern ////////////////////////////////////////////////////////////////////////////////////////
keyset("n", "<space>e",
	function()
		if vim.bo.filetype == "fern" then
			vim.cmd.wincmd "p"
		else
			vim.cmd.Fern(".", "-reveal=%", "-drawer", "-width=40")
		end
	end,
	noremap)
-- /////////////////////////////////////////////////////////////////////////////////////////////

-- Telescope ///////////////////////////////////////////////////////////////////////////////////
local telescope_builtin = require('telescope.builtin')
keyset("n", "<leader>ff", telescope_builtin.find_files, {})
keyset("n", "<leader>fg", telescope_builtin.live_grep, {})
keyset("n", "<leader>fb", telescope_builtin.buffers, {})
keyset("n", "<leader>fh", telescope_builtin.help_tags, {})
keyset("n", "<leader>fc", telescope_builtin.commands, {})
-- /////////////////////////////////////////////////////////////////////////////////////////////

-- LSP /////////////////////////////////////////////////////////////////////////////////////////
keyset("n", "<F12>", "<CMD>Lspsaga goto_definition<CR>")
keyset("n", "<S-F12>", "<CMD>Lspsaga finder<CR>")
keyset("n", "<A-F12>", "<CMD>Lspsaga peek_definition<CR>")
keyset("n", "K", "<CMD>Lspsaga hover_doc<CR>")
keyset("n", "<F2>", "<CMD>Lspsaga rename<CR>")
keyset("n", "<C-k><C-k>", "<CMD>Lspsaga code_action<CR>")
keyset("n", "[g", vim.diagnostic.goto_prev)
keyset("n", "]g", vim.diagnostic.goto_next)
keyset("n", "<C-k><C-e>", function() vim.lsp.buf.format({ async = true }) end)
-- /////////////////////////////////////////////////////////////////////////////////////////////

-- DAP /////////////////////////////////////////////////////////////////////////////////////////
local dap = require('dap')
keyset('n', '<F5>', function() dap.continue() end)
keyset('n', '>S-F5>', function () dap.terminate() end)
keyset('n', '<A-F5>', function() dap.run_last() end)
keyset('n', '<F10>', function() dap.step_over() end)
keyset('n', '<F11>', function() dap.step_into() end)
keyset('n', '<S-F11>', function() dap.step_out() end)
keyset('n', '<Leader>bb', function() dap.toggle_breakpoint() end)
keyset('n', '<Leader>bl', function() dap.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
keyset('n', '<Leader>bc', function() dap.toggle_breakpoint(vim.fn.input('Condition: '), nil, nil) end)
keyset('n', '<Leader>bh', function() dap.toggle_breakpoint(nil, vim.fn.input('Hit count: '), nil) end)
keyset('n', '<Leader>bd', function() dap.clear_breakpoints() end)
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

keyset("n", "<leader>t", "<CMD>Themery<CR>")
