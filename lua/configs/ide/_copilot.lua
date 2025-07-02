return {
	"zbirenbaum/copilot.lua",
	enabled = require("configs").ai.enable and require("configs").ai.use_copilot,
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
