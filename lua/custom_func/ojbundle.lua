-- compile_flags.txtを上のディレクトリにたどって探す
local function find_compile_flags(start_path)
	-- compile_flags.txt が見つかるまで親ディレクトリを探す
	local root_dir = require("lspconfig").util.root_pattern "compile_flags.txt" (start_path)
	return root_dir and (root_dir .. "/compile_flags.txt") or nil
end

-- compile_flags.txt から -I パスを抽出する
local function extract_include_paths(compile_flags_path)
	local include_paths = {}
	local base_dir = vim.fn.fnamemodify(compile_flags_path, ":h")
	for line in io.lines(compile_flags_path) do
		if line:match("^%-I") then
			local rel_path = line:match("^%-I%s*(.+)$")
			if rel_path then
				local abs_path = vim.fn.fnamemodify(base_dir .. "/" .. rel_path, ":p")
				table.insert(include_paths, "-I" .. abs_path)
			end
		end
	end
	return include_paths
end

-- コマンド定義
vim.api.nvim_create_user_command("Ojbundle", function()
	local buf_path = vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		vim.notify("バッファのパスが取得できません。", vim.log.levels.ERROR)
		return
	end

	local compile_flags_path = find_compile_flags(buf_path)
	if not compile_flags_path then
		vim.notify("compile_flags.txt が見つかりません。", vim.log.levels.ERROR)
		return
	end

	local include_paths = extract_include_paths(compile_flags_path)
	local include_str = table.concat(include_paths, " ")

	-- 出力ファイル名を作成
	local dir_name = vim.fn.fnamemodify(buf_path, ":p:h")          -- ディレクトリ名
	local file_name = vim.fn.fnamemodify(buf_path, ":t:r")         -- ファイル名（拡張子なし）
	local ext = vim.fn.fnamemodify(buf_path, ":e")                 -- 拡張子
	local outpath = dir_name .. "/" .. file_name .. "_bundle." .. ext -- 出力ファイル名

	local cmd = string.format("oj-bundle %s %s > %s", vim.fn.shellescape(buf_path), include_str, vim.fn.shellescape(outpath))

	vim.notify("compile_flags.txt : " .. compile_flags_path .. "\n実行コマンド: " .. cmd, vim.log.levels.INFO, { title = "Ojbundle" })

	vim.fn.system(cmd)
	local exit_code = vim.v.shell_error

	if exit_code ~= 0 then
		vim.notify("oj-bundle 実行に失敗しました", vim.log.levels.ERROR)
	end
end, {})
