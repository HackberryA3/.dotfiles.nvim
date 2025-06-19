return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "buffers", -- set to "tabs" to only show tabpages instead
			themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
			numbers = "none",
			close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
			right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
			left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
			middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
			indicator = {
				icon = '▎', -- this should be omitted if indicator style is not 'icon'
				style = 'underline',
			},
			buffer_close_icon = '󰅖',
			modified_icon = '●',
			close_icon = '',
			left_trunc_marker = '',
			right_trunc_marker = '',
			diagnostics = "nvim_lsp",
			diagnostics_update_in_insert = true,
			-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local s = ""
				for e, n in pairs(diagnostics_dict) do
					if e ~= "hint" then
						local sym = e == "error" and "󰅙" or (e == "warning" and "" or "" )
						s = s .. " " .. sym .. n
					end
				end
				return s
			end,
			offsets = {
				{
					filetype = "fern",
					text = "File Explorer",
					text_align = "left",
					separator = true
				}
			},
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
			-- can also be a table containing 2 custom separators
			-- [focused and unfocused]. eg: { '|', '|' }
			separator_style = "slant",
			always_show_bufferline = true,
			hover = {
				enabled = true,
				delay = 200,
				reveal = {'close'}
			},
			sort_by = 'insert_after_current'
		}
	}
}
