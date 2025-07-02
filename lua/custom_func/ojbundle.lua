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
				local abs_path = rel_path
				if abs_path:sub(1, 1) ~= "/" then
					-- 相対パスの場合、絶対パスに変換
					abs_path = vim.fn.fnamemodify(base_dir .. "/" .. rel_path, ":p")
				end
				table.insert(include_paths, "-I" .. abs_path)
			end
		end
	end
	return include_paths
end

-- 正規表現にマッチするかどうかを返す関数
local function buffer_contains_pattern(pattern)
  -- 現在のバッファの全行を取得
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 各行をループしてパターンにマッチするか確認
  for _, line in ipairs(lines) do
    if string.find(line, pattern) then
      return true
    end
  end

  return false
end

-- コマンド定義
vim.api.nvim_create_user_command("Ojbundle", function()
	-- バッファに#include <atcoder.*>が含まれているか確認
	if buffer_contains_pattern("#include%s*<atcoder.*>") then
		vim.notify("#include <>で読み込んでいます！#include \"\"を使用してください。", vim.log.levels.ERROR)
		return
	end
	if buffer_contains_pattern("#include%s*<boost.*>") then
		vim.notify("#include <>で読み込んでいます！#include \"\"を使用してください。", vim.log.levels.ERROR)
		return
	end


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
