local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed
		}
	end
end

local function lsp_names()
	local clients = {}
	for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
		if client.name == 'null-ls' then -- null-ls なら source を表示
			local sources = {}
			for _, source in ipairs(require('null-ls.sources').get_available(vim.bo.filetype)) do
				table.insert(sources, source.name)
			end
			table.insert(clients, 'null-ls(' .. table.concat(sources, ', ') .. ')')
		else                        -- それ以外は client.name を表示
			if client.name == "copilot" then -- copilot は表示しない
				goto continue
			end
			table.insert(clients, client.name)
		end
		::continue::
	end

	return '󱘖 ' .. table.concat(clients, ' | ')
end

return {
	'nvim-lualine/lualine.nvim',
	dependencies = 'nvim-tree/nvim-web-devicons',
	opts = {
		options = {
			icons_enabled = true,
			theme = 'auto',
			section_separators = { left = '', right = '' },
			component_separators = { left = '', right = '' },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			}
		},
		sections = {
			lualine_a =
			{
				{ 'mode', separator = { left = "", right = "" } }
			},
			lualine_b = {
				{
					'b:gitsigns_head',
					icon = ''
				},
				{
					'diff',
					symbols = { added = ' ', modified = ' ', removed = ' ' },
					source = diff_source
				},
				{
					'diagnostics',
					symbols = { error = '󰅙 ', warn = ' ', info = ' ', hint = '󰛨 ' },
					update_in_insert = true
				}
			},
			lualine_c = {
				{
					lsp_names,
					color = function()
						if lsp_names() == '󱘖 ' then
							return "ErrorMsg"
						end
					end
				},
				{
					'copilot',
					show_colors = true,
				}
			},
			lualine_x = {
				{
					'encoding',
					fmt = function(str)
						return str:upper()
					end
				},
				{
					'fileformat',
					symbols = {
						unix = 'LF',
						dos = 'CRLF',
						mac = 'CR',
					},
				},
				{
					'filetype',
					colored = true,
					icon = { align = 'left' },
					fmt = function(str)
						if #str == 0 then
							return ""
						end
						if #str == 1 then
							return str:upper()
						end
						if str == "cpp" then
							return "C++"
						end
						if str == "cs" then
							return "C#"
						end
						return str:sub(1, 1):upper() .. str:sub(2)
					end
				}
			},
			lualine_y = { 'progress', },
			lualine_z = {
				{
					'filename',
					symbols = { modified = '●', readonly = '', unnamed = '󱙃', newfile = '󰫻󰫲󰬄' },
					separator = { left = "", right = "" }
				},

			}
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { 'filename' },
			lualine_x = { 'location' },
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {
			lualine_a = {
				{
					'buffers',
					separator = { left = "", right = "" },
					show_filename_only = true,
					hide_filename_extension = false,
					show_modified_status = true,

					mode = 0,

					max_length = vim.o.columns * 2 / 3,

					filetype_names = {
						TelescopePrompt = 'Telescope',
						fern = "Fern"
					},
					fmt = function(str)
						if str == "Fern" then
							return ""
						end
						return str
					end,

					use_mode_colors = false,

					symbols = {
						modified = ' ●',
						alternate_file = '#',
						directory = '',
					},
				}
			},
			lualine_z = {
				{
					'tabs',
					separator = { left = "", right = "" },
					tab_max_length = 40,
					max_length = vim.o.columns / 3,
					mode = 2,
					path = 0,
					use_mode_colors = false,
					show_modified_status = false,

					fmt = function(name, context)
						-- Show + if buffer is modified in tab
						local buflist = vim.fn.tabpagebuflist(context.tabnr)
						local winnr = vim.fn.tabpagewinnr(context.tabnr)
						local bufnr = buflist[winnr]
						local mod = vim.fn.getbufvar(bufnr, '&mod')

						return name .. (mod == 1 and ' ●' or '')
					end
				}
			}
		},
		winbar = {},
		inactive_winbar = {},
		extensions = { 'lazy', 'fern' }
	}
}
