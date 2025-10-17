return {
	"williamboman/mason-lspconfig.nvim",
	version = "^1.0.0",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"ray-x/lsp_signature.nvim"
	},
	config = function()
		local on_attach = function(client, bufnr)
		-- LSPが持つフォーマット機能を無効化する
		-- →例えばtsserverはデフォルトでフォーマット機能を提供しますが、利用したくない場合はコメントアウトを解除してください
		--client.server_capabilities.documentFormattingProvider = false

	--[[ 	require("lsp_signature").on_attach({
			bind = true,
			handler_opts = {
				border = "rounded"
			},
		}, bufnr) ]]

		-- ハイライト
		if client.server_capabilities.documentHighlightProvider then
			vim.cmd([[
				hi! LspReferenceRead cterm=bold ctermbg=24 guibg=#444488
				hi! LspReferenceText cterm=bold ctermbg=24 guibg=#444488
				hi! LspReferenceWrite cterm=bold ctermbg=24 guibg=#444488
			]])
			vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
			vim.api.nvim_clear_autocmds({
				buffer = bufnr,
				group = 'lsp_document_highlight',
			})
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				group = 'lsp_document_highlight',
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				group = 'lsp_document_highlight',
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- 自動で診断を表示
		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			callback = function()
				local ok = false;
				local row, col = unpack(vim.api.nvim_win_get_cursor(0)) --カーソル位置
				local diagnostics = vim.diagnostic.get()
				for _, dia in pairs(diagnostics) do
					local diaBufnr = dia["bufnr"]
					local sl = dia["lnum"] + 1
					local el = dia["end_lnum"] + 1
					local sc = dia["col"]
					local ec = dia["end_col"]

					if diaBufnr ~= bufnr then
						goto continue
					end

					if sl <= row and row <= el and sc <= col and col < ec then
						ok = true
						break
					end

					::continue::
				end

				if ok then
					local opts = {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = 'rounded',
						source = 'always',
						prefix = ' ',
						scope = 'cursor',
					}
					vim.diagnostic.open_float(nil, opts)
				else
					-- vim.cmd("Lspsaga hover_doc")
				end
			end
		})
	end

	-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.offsetEncoding = { "utf-16" } -- NOTE: CopilotとLSPを同時に動かすと、offsetEncodingがバラバラだ！と怒られるので、utf-16に固定する

	-- この一連の記述で、mason.nvimでインストールしたLanguage Serverが自動的に個別にセットアップされ、利用可能になります
	require("mason-lspconfig").setup({
		ensure_installed = {
			"clangd",
			"omnisharp",
			"jdtls",
			"pyright",
			"lua_ls",

			"html",
			"cssls",
			"tailwindcss",
			"ts_ls",

			"jsonls",
			"lemminx",
			"yamlls",

			"bashls",
			"powershell_es",
		},
		automatic_installation = true,
	})

	require("mason-lspconfig").setup_handlers {
		function(server_name)
			vim.lsp.config(server_name, {
				on_attach = on_attach,
				capabilities = capabilities, --cmpを連携
			})
			vim.lsp.enable(server_name)
		end,
		["lua_ls"] = function()
			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT"
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library"
							}
						}
					},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
		["omnisharp"] = function()
			vim.lsp.config("omnisharp", {
				on_attach = on_attach,
				capabilities = capabilities,
				enable_roslyn_analyzer = true,
				organize_imports_on_format = true,
				enable_import_completion = true
			})
			vim.lsp.enable("omnisharp")
		end
	}

	--[[vim.lsp.config("clangd", {
		on_attach = on_attach,
		capabilities = capabilities,
		cmd = { "clangd" }
	})
	vim.lsp.enable("clangd")]]
	end
}
