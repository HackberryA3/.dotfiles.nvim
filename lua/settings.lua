local opt = vim.opt

opt.mouse = 'a' --マウス有効化
opt.title = true
opt.background = "dark"
if vim.fn.exists('+termguicolors') == 1 and vim.env.TERM_PROGRAM ~= "Apple_Terminal" then
	opt.termguicolors = true --True Color
end
opt.laststatus = 3 -- ステータスラインをグローバル化



opt.updatetime = 200 --CursorHoldが発火されるまでの時間（カーソルを止めてからハイライトされるまでの時間）
opt.cmdheight = 1
vim.cmd'set clipboard+=unnamedplus' --クリップボードを共有

--opt.ambiwidth = 'double' --全角文字表示設定
opt.helplang = 'ja,en' --ヘルプを日本語表示

opt.ignorecase = true --検索時に大文字の違いを無視
opt.smartcase = true --検索時に大文字があれば、違いを区別

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

opt.autoread = true --ファイルが他で変更されたら読み直す
vim.api.nvim_create_augroup('Autoread', {}) --ファイルが他で変更されて、読み込んだときにLSPを再起動する (clangdがうまく動かなかったから)
vim.api.nvim_create_autocmd('FileChangedShellPost', {
	group = "Autoread",
	command = "e | LspRestart",
	desc = "Restart lsp when changed the file on disk"
})
