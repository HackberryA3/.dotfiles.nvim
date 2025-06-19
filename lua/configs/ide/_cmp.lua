return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-calc",
		"saadparwaiz1/cmp_luasnip"
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local copilot = require("copilot.suggestion")

		local cmp_kinds = {
			Text = '  ',
			Method = '󰊕  ',
			Function = '󰊕  ',
			Constructor = '󰒓  ',
			Field = '󰫧  ',
			Variable = '󰫧  ',
			Class = '󰆧  ',
			Interface = '  ',
			Module = '󰅩  ',
			Property = '󰖷  ',
			Unit = '  ',
			Value = '  ',
			Enum = '󰉹  ',
			Keyword = '󰌆  ',
			Snippet = '󰅌  ',
			Color = '󰏘  ',
			File = '󰈔  ',
			Reference = '󰷊  ',
			Folder = '󰉋  ',
			EnumMember = '  ',
			Constant = '󰌾  ',
			Struct = '󰆩  ',
			Event = '󱐋  ',
			Operator = '󰪚  ',
			TypeParameter = '  ',
		}

		cmp.setup({
			sources = {
				{ name = "nvim_lsp" }, --ソース類を設定
				{ name = "buffer" },
				{ name = "path" },
				{ name = "calc" },
				{ name = "luasnip" },
			},
			mapping = cmp.mapping.preset.insert({
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<Up>"] = cmp.mapping.select_prev_item(), --Ctrl+pで補完欄を一つ上に移動
				["<Down>"] = cmp.mapping.select_next_item(), --Ctrl+nで補完欄を一つ下に移動
				["<C-l>"] = cmp.mapping.complete(),
				["<ESC>"] = cmp.mapping.abort(),
				["<TAB>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true }) --Ctrl+yで補完を選択確定
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif copilot.is_visible() then
						copilot.accept()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-TAB>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			experimental = {
				ghost_text = true,
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end
			},
			formatting = {
				fields = { "kind", "abbr" },
				format = function(_, vim_item)
					local MAX_LABEL_WIDTH = 25
					local MIN_LABEL_WIDTH = 25
					local ELLIPSIS_CHAR = '…'
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
					elseif string.len(label) < MIN_LABEL_WIDTH then
						local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
						vim_item.abbr = label .. padding
					end
					vim_item.kind = cmp_kinds[vim_item.kind] or ""
					return vim_item
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			}
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})

		-- 関数補完をした後に、自動で括弧を挿入
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		cmp.event:on(
			'confirm_done',
			cmp_autopairs.on_confirm_done()
		)
	end
}
