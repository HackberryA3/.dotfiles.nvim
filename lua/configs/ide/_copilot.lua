return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	opts = {
		suggestion = {
			auto_trigger = true,
			keymap = {
				accept = false,
				accept_word = "<C-Right>",
				dissmiss = false
			}
		}
	}
}
