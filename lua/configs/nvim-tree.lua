local function on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))

	local function edit_or_open()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file
			api.node.open.edit()
			-- Close the tree if file was opened
			api.tree.close()
		end
	end

	local function collapse()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- collapse folder
			api.node.open.edit()
		end
	end

	-- open as vsplit on current node
	local function vsplit_preview()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file as vsplit
			api.node.open.vertical()
		end

		-- Finally refocus on tree if it was lost
		api.tree.focus()
	end

	vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
	vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
	vim.keymap.set("n", "h", collapse, opts("Close"))
	vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
	vim.keymap.set("n", "<TAB>", require("nvim-tree-preview").node_under_cursor, opts("Preview"))
end

local function natural_sort(left, right)
	left = left.name:lower()
	right = right.name:lower()

	if left == right then
		return false
	end

	for i = 1, math.max(string.len(left), string.len(right)), 1 do
		local l = string.sub(left, i, -1)
		local r = string.sub(right, i, -1)

		if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
			local l_number = tonumber(string.match(l, "^[0-9]+"))
			local r_number = tonumber(string.match(r, "^[0-9]+"))

			if l_number ~= r_number then
				return l_number < r_number
			end
		elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
			return l < r
		end
	end
end

return {
	on_attach = on_attach,
	sort = {
		sorter = "case_sensitive",
	},
	sort_by = function(nodes)
		table.sort(nodes, natural_sort)
	end,
	view = {
		adaptive_size = true,
	},
	renderer = {
		group_empty = true,
		special_files = {
			"Cargo.toml",
			"Makefile",
			"README.md",
			"readme.md",
			"LICENSE.md",
			"LICENSE",
			"package.json",
			"package-lock.json",
			"yarn.lock",
			"tsconfig.json",
			"compile_commands.json",
			"compile_flags.txt",
			".clang-format",
			".gitignore",
			".gitattributes",
			"Dockerfile",
			"docker-compose.yml",
			".dockerignore",

			".profile",
			".bashrc",
			".bash_profile",
			".bash_login",
			".bash_logout",
			".zshrc",
			"config.fish",
		},
		highlight_git = "all",
		highlight_diagnostics = "all",
		highlight_modified = "all",
		highlight_clipboard = "all",
		indent_markers = {
			enable = true,
		},
		icons = {
			git_placement = "after",
			glyphs = {
				git = {
					unstaged = "",
					staged = "󰱒",
					untracked = "",
					ignored = "󰈉 "
				}
			}
		},
	},
	diagnostics = {
		enable = true,
	},
	filters = {
		git_ignored = false,
	},
}
