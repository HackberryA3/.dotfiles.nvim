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

vim.g.mapleader = " " -- Lazyよりも前に設定する
vim.g.maplocalleader = "\\"

require("lazy").setup({
		-- ヘルプを日本語にする
		"vim-jp/vimdoc-ja",



		-- IDE ///////////////////////////////////////////////////////////////////////////////////////////////////////
		-- シンタックスハイライト
		{
			"nvim-treesitter/nvim-treesitter",
			main = "nvim-treesitter.configs",
			opts = require("configs.treesitter")
		},
		-- LSPマネージャー
		{
			"williamboman/mason.nvim",
			config = true,
			opts = {
				ui = {
					border = "rounded"
				}
			}
		},
		-- LSPとneovimを繋げる
		{
			"neovim/nvim-lspconfig"
		},
		-- lspconfigとmasonを繋げる
		{
			"williamboman/mason-lspconfig.nvim",
			config = function() require("configs.lspconfig") end,
			dependencies = {
				"williamboman/mason.nvim",
				"neovim/nvim-lspconfig",
				"ray-x/lsp_signature.nvim"
			}
		},
		-- lspのUIをかっこよくする
		{
			"nvimdev/lspsaga.nvim",
			opts = require("configs.lspsaga"),
			dependencies = {
				'nvim-treesitter/nvim-treesitter',
				'nvim-tree/nvim-web-devicons'
			}
		},



		-- 補完
		{
			"hrsh7th/nvim-cmp",
			config = function() require("configs.cmp") end,
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-calc",
				"saadparwaiz1/cmp_luasnip"
			}
		},
		-- 関数の引数ヒント
		{
			"ray-x/lsp_signature.nvim",
			opts = {
				hint_prefix = "󰏫 "
			}
		},



		-- スニペット
		"L3MON4D3/LuaSnip",



		-- copilot
		{
			"zbirenbaum/copilot.lua",
			event = "InsertEnter",
			opts = require("configs.copilot")
		},
		{
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
			config = function()
				require("codeium").setup({
				})
			end
		},
		-- ステータスラインに状態を表示
		{ "AndreM222/copilot-lualine" },
		{
			"yetone/avante.nvim",
			event = "VeryLazy",
			lazy = false,
			version = false, -- set this if you want to always pull the latest change
			opts = require("configs.avante"),
			-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
			build = "make",
			-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
			dependencies = {
				"stevearc/dressing.nvim",
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				--- The below dependencies are optional,
				"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
				"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
				"zbirenbaum/copilot.lua", -- for providers='copilot'
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						-- recommended settings
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
							-- required for Windows users
							use_absolute_path = true,
						},
					},
				},
				{
					-- Make sure to set this up properly if you have lazy=true
					'MeanderingProgrammer/render-markdown.nvim',
					opts = {
						file_types = { "markdown", "Avante" },
					},
					ft = { "markdown", "Avante" },
				},
			},
		},



		-- DAP
		"mfussenegger/nvim-dap",
		-- DAP UI
		{
			"rcarriga/nvim-dap-ui",
			config = true,
			dependencies = {
				"mfussenegger/nvim-dap",
				"nvim-neotest/nvim-nio"
			}
		},
		-- デバッグ時の変数の値や、例外の情報を表示する
		{
			"theHamsta/nvim-dap-virtual-text",
			config = true,
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"mfussenegger/nvim-dap"
			},
		},
		-- DAPとMasonをつなげる
		{
			"jay-babu/mason-nvim-dap.nvim",
			config = function()
				require("configs.dap")
			end,
			dependencies = {
				"mfussenegger/nvim-dap",
				"rcarriga/nvim-dap-ui",
				"williamboman/mason.nvim"
			},
		},
		-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////


		-- クイックラン TODO: 言語に合わせてコマンドを書く
		{
			"CRAG666/code_runner.nvim",
			opts = require("configs.code_runner")
		},


		-- ファイラー
		{
			"nvim-tree/nvim-tree.lua",
			main = "nvim-tree",
			opts = require("configs.nvim-tree")
		},
		{
			"b0o/nvim-tree-preview.lua",
			main = "nvim-tree-preview",
			config = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
			}
		},

		-- -- Nerd Fontに対応させる
		{ "lambdalisue/nerdfont.vim" },
		-- Nerd Font(ファイルアイコン等)に色を反映させる
		{
			"lambdalisue/glyph-palette.vim",
			config = function()
				vim.api.nvim_create_augroup('GlyphPallete', {})
				vim.api.nvim_create_autocmd('FileType', {
					group = "GlyphPallete",
					command = "call glyph_palette#apply()",
					desc = "Setting up colors for nerd fonts"
				})
			end,
			dependencies = "lambdalisue/nerdfont.vim"
		},



		-- UI ///////////////////////////////////////////////////////////////////////////////////////////////////////
		-- ステータスライン
		{
			"nvim-lualine/lualine.nvim",
			opts = require("configs.lualine"),
			dependencies = "nvim-tree/nvim-web-devicons",
		},
		-- { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons", opts = require("configs.bufferline") }, -- バッファーライン
		-- 通知トースト
		{
			"rcarriga/nvim-notify",
			priority = 900,
			config = function()
				require("configs.notify")
			end
		},
		-- コマンドライン、通知をリッチにする
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = require("configs.noice"),
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			}
		},
		-- //////////////////////////////////////////////////////////////////////////////////////////////////////////



		-- 便利機能 /////////////////////////////////////////////////////////////////////////////////////////////////
		-- Git
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup(require("configs.gitsigns"))
				require("scrollbar.handlers.gitsigns").setup()
			end,
		},
		-- 万能検索 (ripgrepをインストールする必要あり)
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.6",
			dependencies = {
				"nvim-lua/plenary.nvim"
			}
		},
		-- ターミナル
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			opts = require("configs.toggleterm")
		},
		-- 登録しておいたキー割り当てを表示
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = require("configs.which-key")
		},
		-- LazyGit
		{
			"kdheepak/lazygit.nvim",
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
			}
		},
		-- ウェルカムページ
		{
			'goolord/alpha-nvim',
			config = function()
				require 'alpha'.setup(require 'alpha.themes.theta'.config)
			end,
			dependencies = {
				'nvim-tree/nvim-web-devicons',
				'nvim-lua/plenary.nvim'
			}
		},
		-- //////////////////////////////////////////////////////////////////////////////////////////////////////////



		-- コーディングの便利機能 ///////////////////////////////////////////////////////////////////////////////////
		-- RGB表記に色を付ける
		{
			"brenoprata10/nvim-highlight-colors",
			opts = {
				enable_tailwind = true
			},
			event = "BufEnter *.*"
		},
		-- インデント可視化
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			config = true
		},
		-- 今いるコードブロックを上に表示
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = true,
			opts = {
				multiline_threshold = 1,
				mode = "topline",
			}
		},
		-- 囲み文字を素早く変更
		{
			"kylechui/nvim-surround",
			config = true
		},
		-- 自動で括弧補完
		{
			"windwp/nvim-autopairs",
			config = true,
			event = "InsertEnter"
		},
		-- 言語に合わせたカッコ移動
		{
			"andymass/vim-matchup",
		},
		-- スクロールバー
		{
			"petertriho/nvim-scrollbar",
			config = true,
			opts = {
				handle = {
					blend = 75,
					color = "#FFFFFF"
				}
			}
		},
		-- スクロールを滑らかにする
		{
			"karb94/neoscroll.nvim",
			opts = require("configs.neoscroll")
		},
		-- コメントの切り替え
		{
			"numToStr/Comment.nvim",
			opts = require("configs.comment")
		},
		-- TODOコメントを表示
		{
			"folke/todo-comments.nvim",
			config = true,
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		-- 折りたたみをリッチにする
		{
			-- "anuvyklack/pretty-fold.nvim",
			-- config = true
		},
		-- いろいろなインクリメントに対応
		{
			"monaqa/dial.nvim",
			config = function() require("configs.dial") end
		},
		-- 色々スワップ
		{
			"mizlan/iswap.nvim",
			event = "VeryLazy"
		},
		-- 検索ハイライトの改善
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				require("scrollbar.handlers.search").setup()
			end,
		},
		-- カーソルジャンプ
		{
			'smoka7/hop.nvim',
			version = "*",
			config = true,
		},
		-- fでジャンプできる所をハイライト
		{
			"unblevable/quick-scope",
		},
		-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////



		-- その他 /////////////////////////////////////////////////////////////////////////////////////////////////////
		{
			"wakatime/vim-wakatime",
			lazy = false
		},
		-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////



		-- テーマ ////////////////////////////////////////////////////////////////////////////////////////////////////
		{ "zaldih/themery.nvim",   opts = require("configs.themery") }, -- テーマピッカー
		{ "sainnhe/everforest",    priority = 1000 },
		{ "rebelot/kanagawa.nvim", priority = 1000 },
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
		-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////
	},
	{
		ui = {
			border = "rounded"
		}
	}
)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	command = "set filetype=jsonc",
	desc = "Convert filetype from json to jsonc to allow comments"
})
