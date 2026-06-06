local M = {}

local ns = vim.api.nvim_create_namespace("conops")
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
local config = { cmd = nil, enabled = true }
local sev = { error = vim.diagnostic.severity.ERROR, warning = vim.diagnostic.severity.WARN }
local warned = false

-- Resolve the conops binary: explicit cmd, then the bundled bin/, then PATH.
function M.binary()
	if config.cmd then
		return config.cmd
	end
	local bundled = root .. "/bin/conops"
	if vim.uv.fs_stat(bundled) then
		return bundled
	end
	if vim.fn.executable("conops") == 1 then
		return "conops"
	end
	return nil
end

function M.lint(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not config.enabled or vim.bo[bufnr].filetype ~= "conops" then
		return
	end
	local file = vim.api.nvim_buf_get_name(bufnr)
	-- The checker reads a file path, so only lint saved (unmodified) buffers.
	if file == "" or vim.bo[bufnr].modified then
		return
	end
	local cmd = M.binary()
	if not cmd then
		if not warned then
			warned = true
			vim.notify(
				"conops.nvim: 'conops' not found (run :ConopsInstall or add to PATH); diagnostics off",
				vim.log.levels.WARN
			)
		end
		return
	end

	vim.system({ cmd, "check", "--json", file }, { text = true }, function(res)
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
			local ok, parsed = pcall(vim.json.decode, res.stdout or "")
			if not ok or type(parsed) ~= "table" then
				vim.diagnostic.reset(ns, bufnr)
				return
			end
			local items = {}
			for _, d in ipairs(parsed) do
				items[#items + 1] = {
					lnum = math.max((d.line or 1) - 1, 0),
					col = math.max((d.column or 1) - 1, 0),
					end_lnum = math.max((d.endLine or d.line or 1) - 1, 0),
					end_col = math.max((d.endColumn or d.column or 1) - 1, 0),
					severity = sev[d.severity] or vim.diagnostic.severity.ERROR,
					message = d.message or "",
					code = d.code,
					source = "conops",
				}
			end
			vim.diagnostic.set(ns, bufnr, items)
		end)
	end)
end

function M.install()
	vim.system({ "sh", root .. "/scripts/fetch-binary.sh" }, { text = true }, function(res)
		vim.schedule(function()
			vim.notify("conops.nvim: " .. ((res.stdout or "") .. (res.stderr or "")), vim.log.levels.INFO)
		end)
	end)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})
end

return M
