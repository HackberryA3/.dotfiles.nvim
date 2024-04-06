-- Lazy.nvim /////////////////////////////////////////////////////////////////////////////////////////////////////
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

require("lazy").setup({
	-- コア機能
	"vim-jp/vimdoc-ja", -- ヘルプを日本語にする
	{ "williamboman/mason.nvim", config = true }, -- LSPマネージャー
	{ "neovim/nvim-lspconfig" }, -- LSPとneovimを繋げる
	{ "williamboman/mason-lspconfig.nvim", config = function() require("configs.lspconfig") end, dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "ray-x/lsp_signature.nvim" } }, -- lspconfigとmasonを繋げる
	{ "nvimdev/lspsaga.nvim", opts = require("configs.lspsaga"), dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' } }, -- lspのUIをかっこよくする
	{ "hrsh7th/nvim-cmp", config = function() require("configs.cmp") end }, -- 補完
	{ "hrsh7th/cmp-nvim-lsp", dependencies = "hrsh7th/nvim-cmp", }, -- LSP補完
	{ "hrsh7th/cmp-buffer", dependencies = "hrsh7th/nvim-cmp" }, -- Buffer補完
	{ "hrsh7th/cmp-path", dependencies = "hrsh7th/nvim-cmp" }, -- パス補完
	{ "hrsh7th/cmp-cmdline", dependencies = "hrsh7th/nvim-cmp" }, -- コマンド補完
	{ "hrsh7th/cmp-calc", dependencies = "hrsh7th/nvim-cmp" }, -- 式を書くと計算結果を補完する
	{ "L3MON4D3/LuaSnip" }, -- スニペット
	{ "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip", "hrsh7th/nvim-cmp" } }, -- スニペット補完
	{ "ray-x/lsp_signature.nvim", opts = { hint_prefix = "󰏫 " } }, -- 関数の引数ヒント

	{ "nvim-treesitter/nvim-treesitter", main = "nvim-treesitter.configs", opts = require("configs.treesitter") }, -- シンタックスハイライト
	{ "zbirenbaum/copilot.lua", event = "InsertEnter", opts = require("configs.copilot") }, -- copilot

	{ "mfussenegger/nvim-dap" }, -- DAP
	{ "rcarriga/nvim-dap-ui", config = true, dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }, -- DAP UI
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui", "williamboman/mason.nvim" },
		config = function()
			require("configs.dap")
		end
	},                                                                                                                                -- DAPとMasonを繋げる
	{ "theHamsta/nvim-dap-virtual-text", dependencies = { "nvim-treesitter/nvim-treesitter", "mfussenegger/nvim-dap" }, config = true }, -- デバッグ時の変数の値や、例外の情報を表示する

	{ "CRAG666/code_runner.nvim",        opts = require("configs.code_runner") },                                                                             -- クイックラン TODO: 言語に合わせてコマンドを書く

	-- テーマ
	{ "zaldih/themery.nvim",             opts = require("configs.themery") }, -- テーマピッカー
	{ "sainnhe/everforest",              priority = 1000 },
	{ "rebelot/kanagawa.nvim",           priority = 1000 },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
			integrations = {
				fern = true,
				fidget = true,
				lsp_saga = true,
				mason = true,
				mini = true,
				noice = true,
				notify = true,
				telescope = {
					enabled = true
				}
			}
		}
	},

	-- ファイラー
	{ "lambdalisue/fern.vim", },                                               -- ファイラー
	{ "lambdalisue/fern-hijack.vim", dependencies = "lambdalisue/fern.vim" },  -- ファイラーをFernにする
	{ "lambdalisue/fern-git-status.vim", dependencies = "lambdalisue/fern.vim" }, -- FernにGit Statusを表示する

	-- フォント
	{ "lambdalisue/nerdfont.vim" },                                                                                   -- Nerd Fontに対応させる
	{ "lambdalisue/fern-renderer-nerdfont.vim", dependencies = { "lambdalisue/fern.vim", "lambdalisue/nerdfont.vim" } }, -- Nerd FontをFernに対応させる
	{ "lambdalisue/glyph-palette.vim", dependencies = "lambdalisue/nerdfont.vim" },                                   -- Nerd Font(ファイルアイコン等)に色を反映させる

	-- UI
	{ "nvim-lualine/lualine.nvim", dependencies = "nvim-tree/nvim-web-devicons", opts = require("configs.lualine") },                             -- ステータスライン
	-- { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons", opts = require("configs.bufferline") }, -- バッファーライン
	{ "rcarriga/nvim-notify", config = function() require("configs.notify") end },                                                                -- 通知トースト
	{ "folke/noice.nvim", event = "VeryLazy", opts = require("configs.noice"), dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", } }, -- コマンドライン、通知をリッチにする
	{ "AndreM222/copilot-lualine" },                                                                                                              -- Copilot のステータスを表示する

	-- 便利機能
	{ "dinhhuy258/git.nvim", config = true },                                                    -- Git
	{ "lewis6991/gitsigns.nvim", opts = require("configs.gitsigns") },                           -- Git sign
	{ "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } }, -- 万能検索 (ripgrepをインストールする必要あり)
	{ "akinsho/toggleterm.nvim", version = "*", opts = require("configs.toggleterm") },          -- ターミナル

	-- コーディングの便利機能
	{ "brenoprata10/nvim-highlight-colors", opts = { enable_tailwind = true }, event = "BufEnter *.*" }, -- RGB表記に色を付ける
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },                           -- インデント可視化
	{ "kylechui/nvim-surround", config = true },                                                      -- 囲み文字を素早く変更
	{ "windwp/nvim-autopairs", config = true, event = "InsertEnter", },                               -- 自動で括弧補完
	{ "karb94/neoscroll.nvim", opts = require("configs.neoscroll") },                                 -- スクロールを滑らかにする
	{ "numToStr/Comment.nvim", opts = require("configs.comment") },                                   -- コメントの切り替え
	{ "anuvyklack/pretty-fold.nvim", config = true },                                                 -- 折りたたみをリッチにする
	{ "monaqa/dial.nvim", config = function() require("configs.dial") end }                           -- いろいろなインクリメントに対応
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	command = "set filetype=jsonc",
	desc = "Convert filetype from json to jsonc to allow comments"
})

-- Fern ///////////////////////////////////////////////////////////////////////////////////////////////////////
vim.g['fern#default_hidden'] = 1 -- 隠しファイルを表示
vim.g['fern#renderer'] = 'nerdfont'
vim.api.nvim_create_augroup("Fern", {})
vim.api.nvim_create_autocmd("WinEnter", {
	group = "Fern",
	callback = function()
		if (vim.bo.filetype ~= "fern") then
			vim.cmd("FernDo close -stay")
		end
	end,
	desc = "Auto close the fern drawer when any files are opened"
})
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Glyph Pallte ///////////////////////////////////////////////////////////////////////////////////////////////
vim.api.nvim_create_augroup('GlyphPallete', {})
vim.api.nvim_create_autocmd('FileType', {
	group = "GlyphPallete",
	command = "call glyph_palette#apply()",
	desc = "Setting up colors for nerd fonts"
})
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////
