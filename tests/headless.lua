local DIR = vim.env.PLUGIN_DIR

-- 1. parser loads
assert(pcall(vim.treesitter.language.add, "conops"), "parser load failed")

-- 2. highlights query parses against the parser
local scm = io.open(DIR .. "/queries/conops/highlights.scm"):read("*a")
assert((pcall(vim.treesitter.query.parse, "conops", scm)), "highlights query failed to parse")

-- 3. ftdetect maps *.conops
dofile(DIR .. "/ftdetect/conops.lua")
assert(vim.filetype.match({ filename = "x.conops" }) == "conops", "ftdetect failed")

-- 4. diagnostics from the checker via vim.diagnostic
require("conops").setup({ cmd = vim.env.CONOPS_BIN })
vim.cmd.edit(vim.env.CONOPS_FIX)
vim.bo.filetype = "conops"
require("conops").lint(0)
vim.wait(5000, function() return #vim.diagnostic.get(0) > 0 end)
local d = vim.diagnostic.get(0)
assert(#d >= 1, "expected diagnostics, got " .. #d)
assert(d[1].code == "name-conflict", "expected name-conflict, got " .. tostring(d[1].code))
assert(d[1].lnum == 1, "expected diagnostic on line 2 (lnum 1), got " .. tostring(d[1].lnum))

print("ALL TESTS PASS")
vim.cmd("qa!")
