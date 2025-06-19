return {
	'MeanderingProgrammer/render-markdown.nvim',
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	opts = {
		latex = { enabled = false },
		win_options = { conceallevel = { rendered = 2 } },
		file_types = { 'markdown', 'Avante' },
	},
	ft = { 'markdown', 'Avante' },
}
