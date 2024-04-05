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
local builtin = require('telescope.builtin')
keyset("n", "<leader>ff", builtin.find_files, {})
keyset("n", "<leader>fg", builtin.live_grep, {})
keyset("n", "<leader>fb", builtin.buffers, {})
keyset("n", "<leader>fh", builtin.help_tags, {})
keyset("n", "<leader>fc", builtin.commands, {})
-- /////////////////////////////////////////////////////////////////////////////////////////////

-- LSP /////////////////////////////////////////////////////////////////////////////////////////
keyset("n", "<F12>", "<CMD>Lspsaga goto_definition<CR>")
keyset("n", "<S-F12>", "<CMD>Lspsaga finder<CR>")
keyset("n", "<A-F12>", "<CMD>Lspsaga peek_definition<CR>")
keyset("n", "K", "<CMD>Lspsaga hover_doc<CR>")
keyset("n", "<C-m>", vim.lsp.buf.signature_help)
keyset("n", "<F2>", "<CMD>Lspsaga rename<CR>")
keyset("n", "<C-k><C-k>", "<CMD>Lspsaga code_action<CR>")
keyset("n", "[g", vim.diagnostic.goto_prev)
keyset("n", "]g", vim.diagnostic.goto_next)
keyset("n", "<C-k><C-e>", function() vim.lsp.buf.format({ async = true }) end)
-- /////////////////////////////////////////////////////////////////////////////////////////////

-- DAP /////////////////////////////////////////////////////////////////////////////////////////
keyset('n', '<F5>', function() require('dap').continue() end)
keyset('n', '<F10>', function() require('dap').step_over() end)
keyset('n', '<F11>', function() require('dap').step_into() end)
keyset('n', '<S-F11>', function() require('dap').step_out() end)
keyset('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
keyset('n', '<Leader>B', function() require('dap').set_breakpoint() end)
keyset('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
keyset('n', '<Leader>dr', function() require('dap').repl.open() end)
keyset('n', '<Leader>dl', function() require('dap').run_last() end)
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
