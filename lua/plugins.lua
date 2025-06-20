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

vim.g.mapleader = " " -- NOTE: Lazyよりも前に設定する
vim.g.maplocalleader = "\\"

local plugins = {
	{ conf = "ide._treesitter", enable = true }, -- シンタックスハイライト
	{ conf = "ide._mason", enable = true }, -- LSP, DAPマネージャー
	{ conf = "ide._lspconfig", enable = true }, -- LSPとneovimを繋げる
	{ conf = "ide._mason-lspconfig", enable = true }, -- lspconfigとmasonを繋げる
	{ conf = "ide._lspsaga", enable = true }, -- lspのUIをかっこよくする

	{ conf = "ide._cmp", enable = true }, -- 補完
	{ conf = "ide._lsp_signature", enable = true }, -- 関数の引数ヒント

	{ conf = "ide._luasnip", enable = true }, -- スニペット

	{ conf = "ide._copilot", enable = true }, -- copilot
	{ conf = "ide._copilot-lualine", enable = true }, -- ステータスラインにcopilotの状態を表示
	{ conf = "ide._codeium", enable = false }, -- codeium
	{ conf = "ide._avante", enable = true }, -- AI統合

	{ conf = "ide._dap", enable = true }, -- DAP
	{ conf = "ide._dap-ui", enable = true }, -- DAP UI
	{ conf = "ide._dap-virtual-text", enable = true }, -- デバッグ時の変数の値や、例外の情報を表示する
	{ conf = "ide._mason-dap", enable = true }, -- DAPとMasonをつなげる
	{ conf = "ide._code_runner", enable = true }, -- クイックラン

	{ conf = "editor._nvim-tree", enable = true }, -- ファイラー
	{ conf = "editor._nvim-tree-preview", enable = true }, -- ファイラーのプレビュー
	{ conf = "editor._telescope", enable = true }, -- NOTE: 万能検索 (ripgrepをインストールする必要あり)
	{ conf = "editor._toggleterm", enable = true }, -- ターミナル
	{ conf = "editor._which-key", enable = true }, -- 登録しておいたキー割り当てを表示
	{ conf = "editor._vimdoc-ja", enable = true }, -- ヘルプを日本語にする
	{ conf = "editor._hop", enable = true }, -- カーソルジャンプ
	{ conf = "editor._quick-scope", enable = true }, -- fでジャンプできる所をハイライト
	{ conf = "editor._scrollbar", enable = true }, -- スクロールバー
	{ conf = "editor._neoscroll", enable = true }, -- スクロールを滑らかにする

	{ conf = "ui._nerdfont", enable = true }, -- Nerd Fontに対応させる
	{ conf = "ui._glyph-palette", enable = true }, -- Nerd Font(ファイルアイコン等)に色を反映させる

	{ conf = "ui._latex", enable = true }, -- latexをレンダリング
	{ conf = "ui._render-markdown", enable = true }, -- markdownレンダリング

	{ conf = "ui._lualine", enable = true }, -- ステータスライン
	{ conf = "ui._bufferline", enable = false }, -- バッファーライン
	{ conf = "ui._notify", enable = true }, -- 通知トースト
	{ conf = "ui._noice", enable = true }, -- コマンドライン、通知をリッチにする
	{ conf = "ui._alpha", enable = true }, -- ウェルカムページ

	{ conf = "git._gitsigns", enable = true }, -- Git
	{ conf = "git._lazygit", enable = true }, -- LazyGit

	{ conf = "code._highlight-colors", enable = true }, -- RGB表記に色を付ける
	{ conf = "code._indent-blankline", enable = true }, -- インデント可視化
	{ conf = "code._treesitter-context", enable = true }, -- 今いるコードブロックを上に表示
	{ conf = "code._todo-comments", enable = true }, -- TODOコメントを表示
	{ conf = "code._ufo", enable = true }, -- 折りたたみを改善
	{ conf = "code._pretty-fold", enable = false }, -- 折りたたみをリッチにする
	{ conf = "code._hlslens", enable = true }, -- 検索ハイライトの改善

	{ conf = "util._surround", enable = true }, -- 囲み文字を素早く変更
	{ conf = "util._autopairs", enable = true }, -- 自動で括弧補完
	{ conf = "util._matchup", enable = true }, -- 言語に合わせたカッコ移動
	{ conf = "util._comment", enable = true }, -- コメントの切り替え
	{ conf = "util._dial", enable = true }, -- いろいろなインクリメントに対応
	{ conf = "util._iswap", enable = true }, -- 色々スワップ

	{ conf = "_wakatime", enable = false }, -- WakaTime

	{ conf = "theme._themery", enable = true }, -- テーマピッカー
	{ conf = "theme._everforest", enable = true }, -- everforest
	{ conf = "theme._kanagawa", enable = true }, -- kanagawa
	{ conf = "theme._catppuccin", enable = true }, -- catppuccin
}

local function load_plugins()
	local settings = {}
	for _, plugin in ipairs(plugins) do
		if plugin.enable then
			table.insert(settings, require("configs." .. plugin.conf))
		end
	end

	return settings
end

require("lazy").setup(
	load_plugins(),
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
