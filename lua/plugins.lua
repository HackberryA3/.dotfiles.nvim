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
	{ conf = "ide.treesitter", enable = true }, -- シンタックスハイライト
	{ conf = "ide.mason", enable = true }, -- LSP, DAPマネージャー
	{ conf = "ide.lspconfig", enable = true }, -- LSPとneovimを繋げる
	{ conf = "ide.mason-lspconfig", enable = true }, -- lspconfigとmasonを繋げる
	{ conf = "ide.lspsaga", enable = true }, -- lspのUIをかっこよくする

	{ conf = "ide.cmp", enable = true }, -- 補完
	{ conf = "ide.lsp_signature", enable = true }, -- 関数の引数ヒント

	{ conf = "ide.luasnip", enable = true }, -- スニペット

	{ conf = "ide.copilot", enable = true }, -- copilot
	{ conf = "ide.copilot-lualine", enable = true }, -- ステータスラインにcopilotの状態を表示
	{ conf = "ide.codeium", enable = false }, -- codeium
	{ conf = "ide.avante", enable = true }, -- AI統合

	{ conf = "ide.dap", enable = true }, -- DAP
	{ conf = "ide.dap-ui", enable = true }, -- DAP UI
	{ conf = "ide.dap-virtual-text", enable = true }, -- デバッグ時の変数の値や、例外の情報を表示する
	{ conf = "ide.mason-dap", enable = true }, -- DAPとMasonをつなげる
	{ conf = "ide.code_runner", enable = true }, -- クイックラン

	{ conf = "ui.nvim-tree", enable = true }, -- ファイラー
	{ conf = "ui.nvim-tree-preview", enable = true }, -- ファイラーのプレビュー

	{ conf = "ui.nerdfont", enable = true }, -- Nerd Fontに対応させる
	{ conf = "ui.glyph-palette", enable = true }, -- Nerd Font(ファイルアイコン等)に色を反映させる

	{ conf = "ui.latex", enable = true }, -- latexをレンダリング
	{ conf = "ui.render-markdown", enable = true }, -- markdownレンダリング

	{ conf = "ui.lualine", enable = true }, -- ステータスライン
	{ conf = "ui.bufferline", enable = false }, -- バッファーライン
	{ conf = "ui.notify", enable = true }, -- 通知トースト
	{ conf = "ui.noice", enable = true }, -- コマンドライン、通知をリッチにする
	{ conf = "ui.alpha", enable = true }, -- ウェルカムページ
	{ conf = "ui.scrollbar", enable = true }, -- スクロールバー
	{ conf = "ui.neoscroll", enable = true }, -- スクロールを滑らかにする

	{ conf = "git._gitsigns", enable = true }, -- Git
	{ conf = "git.lazygit", enable = true }, -- LazyGit

	{ conf = "editor.telescope", enable = true }, -- 万能検索 (ripgrepをインストールする必要あり)
	{ conf = "editor.toggleterm", enable = true }, -- ターミナル
	{ conf = "editor.which-key", enable = true }, -- 登録しておいたキー割り当てを表示
	{ conf = "editor.vimdoc-ja", enable = true }, -- ヘルプを日本語にする
	{ conf = "editor.hop", enable = true }, -- カーソルジャンプ
	{ conf = "editor.quick-scope", enable = true }, -- fでジャンプできる所をハイライト

	{ conf = "code.highlight-colors", enable = true }, -- RGB表記に色を付ける
	{ conf = "code.indent-blankline", enable = true }, -- インデント可視化
	{ conf = "code.treesitter-context", enable = true }, -- 今いるコードブロックを上に表示
	{ conf = "code.todo-comments", enable = true }, -- TODOコメントを表示
	{ conf = "code.pretty-fold", enable = false }, -- 折りたたみをリッチにする
	{ conf = "code.hlslens", enable = true }, -- 検索ハイライトの改善

	{ conf = "util.surround", enable = true }, -- 囲み文字を素早く変更
	{ conf = "util.autopairs", enable = true }, -- 自動で括弧補完
	{ conf = "util.matchup", enable = true }, -- 言語に合わせたカッコ移動
	{ conf = "util.comment", enable = true }, -- コメントの切り替え
	{ conf = "util.dial", enable = true }, -- いろいろなインクリメントに対応
	{ conf = "util.iswap", enable = true }, -- 色々スワップ

	{ conf = "wakatime", enable = false }, -- WakaTime

	{ conf = "theme.themery", enable = true }, -- テーマピッカー
	{ conf = "theme.everforest", enable = true }, -- everforest
	{ conf = "theme.kanagawa", enable = true }, -- kanagawa
	{ conf = "theme.catppuccin", enable = true }, -- catppuccin
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
