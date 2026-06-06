if vim.g.loaded_conops then
	return
end
vim.g.loaded_conops = true

local g = vim.api.nvim_create_augroup("conops", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = g,
	pattern = "conops",
	callback = function(a)
		pcall(vim.treesitter.start, a.buf, "conops")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
	group = g,
	pattern = "*.conops",
	callback = function(a)
		require("conops").lint(a.buf)
	end,
})

vim.api.nvim_create_user_command("ConopsInstall", function()
	require("conops").install()
end, { desc = "Download the conops binary from the latest GitHub release" })
