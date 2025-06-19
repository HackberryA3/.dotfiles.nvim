return {
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
}
