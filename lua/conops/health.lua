local M = {}

function M.check()
	vim.health.start("conops.nvim")

	if pcall(vim.treesitter.language.add, "conops") then
		vim.health.ok("tree-sitter parser available")
	else
		vim.health.warn("parser not built", { "Run `make` in the plugin dir (lazy.nvim: build = 'make')" })
	end

	local bin = require("conops").binary()
	if bin then
		vim.health.ok("conops binary: " .. bin)
	else
		vim.health.warn("conops binary not found", { "Run :ConopsInstall, or add 'conops' to PATH" })
	end
end

return M
