local opt = vim.opt

opt.mouse = 'a' --マウス有効化
opt.title = true
opt.showmode = false --モード表示
opt.background = "dark"
if vim.fn.exists('+termguicolors') == 1 and vim.env.TERM_PROGRAM ~= "Apple_Terminal" then
	opt.termguicolors = true --True Color
end
opt.laststatus = 3 -- ステータスラインをグローバル化



opt.updatetime = 0 --CursorHoldが発火されるまでの時間（カーソルを止めてからハイライトされるまでの時間）
opt.cmdheight = 1
opt.clipboard = 'unnamedplus' --クリップボードを共有
-- NOTE: vim.cmd'set clipboard+=unnamedplus' 

-- NOTE: opt.ambiwidth = 'double' --全角文字表示設定
opt.helplang = 'ja,en' --ヘルプを日本語表示

opt.ignorecase = true --検索時に大文字の違いを無視
opt.smartcase = true --検索時に大文字があれば、違いを区別
opt.incsearch = true --検索時に入力毎に検索結果を表示

opt.splitright = true --ウィンドウ分割時に右側に開く
opt.splitbelow = true --ウィンドウ分割時に下側に開く
opt.hidden = true --未保存時にバッファを切り替えようとすると警告が表示されて変更できない問題を解消

opt.number = true --行番号
opt.relativenumber = false --カーソル行からの相対的な行番号
opt.signcolumn = 'yes' --行番号の更に左に目印の列(Git等)が表示される
opt.cursorline = true --カーソル行をハイライト

opt.expandtab = false --タブ挿入時に半角スペース
opt.autoindent = true --インデントする
opt.smartindent = true --{}を考慮して自動でインデントする
opt.tabstop = 4 --タブ挿入時の空白数
opt.shiftwidth = 4 --新しい行の空白数

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]
vim.o.foldcolumn = 'auto:2' -- '0' is not bad
vim.o.foldlevel = 99 -- NOTE: UFOを使う場合は大きい値を設定する
vim.o.foldlevelstart = 99
vim.o.foldenable = true

opt.autoread = true --ファイルが他で変更されたら読み直す
vim.api.nvim_create_augroup('Autoread', {}) --ファイルが他で変更されて、読み込んだときにLSPを再起動する (clangdがうまく動かなかったから)
vim.api.nvim_create_autocmd('FileChangedShellPost', {
	group = "Autoread",
	command = "e | LspRestart",
	desc = "Restart lsp when changed the file on disk"
})



vim.diagnostic.config({
	virtual_text = {
		prefix = '󱓻 ',
	},
	severity_sort = true,
	update_in_insert = true
})
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '󰛨', texthl = 'DiagnosticSignHint' })
