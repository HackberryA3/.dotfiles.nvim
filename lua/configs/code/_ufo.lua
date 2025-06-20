local diagnosticGroups = {
	[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
	[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
	[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
	[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
}
local diagnosticIcons = {
	[vim.diagnostic.severity.HINT] = vim.fn.sign_getdefined(diagnosticGroups[vim.diagnostic.severity.HINT])[1].text,
	[vim.diagnostic.severity.INFO] = vim.fn.sign_getdefined(diagnosticGroups[vim.diagnostic.severity.INFO])[1].text,
	[vim.diagnostic.severity.WARN] = vim.fn.sign_getdefined(diagnosticGroups[vim.diagnostic.severity.WARN])[1].text,
	[vim.diagnostic.severity.ERROR] = vim.fn.sign_getdefined(diagnosticGroups[vim.diagnostic.severity.ERROR])[1].text,
}

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local foldedLines = endLnum - lnum

	-- パーツ
	local leftSep = "╠"
	local rightSep = "╣"
	local centerSep = "═"

	-- 折りたたみ行情報の文字列
	local infoWidth = 0
	local infos = {}
	-- infoの左部分の幅を追加
	infoWidth = infoWidth + vim.fn.strdisplaywidth(leftSep)
	table.insert(infos, {(" %dL "):format(foldedLines), "MoreMsg"})
	infoWidth = infoWidth + vim.fn.strdisplaywidth(infos[#infos][1])

	-- diagnosticの数を取得
	local severityCount = {
		[vim.diagnostic.severity.HINT] = 0,
		[vim.diagnostic.severity.INFO] = 0,
		[vim.diagnostic.severity.WARN] = 0,
		[vim.diagnostic.severity.ERROR] = 0,
	}
	local diagnostics = vim.diagnostic.get(0)
	for _, diagnostic in ipairs(diagnostics) do
		if lnum - 1 <= diagnostic.lnum and diagnostic.end_lnum < endLnum then
			-- 折りたたみ範囲内のdiagnosticがあれば、情報に追加
			local severity = diagnostic.severity
			if severity ~= nil and severityCount[severity] ~= nil then
				severityCount[severity] = severityCount[severity] + 1
			end
		end
	end
	-- 各severityの数をinfoに追加
	for severity, count in pairs(severityCount) do
		if count > 0 then
			table.insert(infos, {("%s%d "):format(diagnosticIcons[severity], count), diagnosticGroups[severity]})
			infoWidth = infoWidth + vim.fn.strdisplaywidth(infos[#infos][1])
		end
	end


	-- infoの右部分の幅を追加して、幅を確定
	infoWidth = infoWidth + vim.fn.strdisplaywidth(rightSep)

	-- 仮想テキストの左部分（行内容をできるだけ表示）
	local contentWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local hlGroup = chunk[2]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if contentWidth + chunkWidth < width - infoWidth - 1 then
			-- まだ表示可能な幅がある場合
			if contentWidth == 0 then
				-- 先頭なら
				local onlySpace = string.match(chunkText, "^%s*$")
				if onlySpace and 2 <= chunkWidth then
					-- 空白のみなら、空白をそのまま表示
					chunkText = leftSep .. string.rep(centerSep, chunkWidth - 2) .. rightSep
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					hlGroup = "MoreMsg"
				end
			end
			table.insert(newVirtText, { chunkText, hlGroup })
			contentWidth = contentWidth + chunkWidth
		else
			-- 表示可能な幅を超える場合は切り詰める
			chunkText = truncate(chunkText, width - infoWidth - contentWidth - 1)
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			contentWidth = contentWidth + chunkWidth
			table.insert(newVirtText, { chunkText, hlGroup })
			break
		end
	end

	local fillWidthL = (width - contentWidth - infoWidth - 1) / 2
	local fillWidthR = ((width - contentWidth - infoWidth - 1) + 2 - 1) / 2
	local fillL = string.rep(centerSep, math.max(fillWidthL, 0))
	local fillR = string.rep(centerSep, math.max(fillWidthR, 0))

	-- サフィックスの構築
	table.insert(newVirtText, { leftSep .. fillL, "MoreMsg" })
	for _, info in ipairs(infos) do
		table.insert(newVirtText, info)
	end
	table.insert(newVirtText, { fillR .. rightSep, "MoreMsg" })

	return newVirtText
end


return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		"luukvbaal/statuscol.nvim"
	},
	main = "ufo",
	config = true,
	opts = {
		provider_selector = function(bufnr, filetype, buftype)
			return { 'treesitter', 'indent' }
		end,
		fold_virt_text_handler = handler,
	}
}
