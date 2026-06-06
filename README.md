# conops.nvim

Neovim support for the [Conops](https://github.com/sstoehrm/conops) language: native
tree-sitter syntax highlighting and on-save diagnostics from the `conops` checker. No
plugin dependencies.

## Install

### lazy.nvim
```lua
{ "sstoehrm/conops.nvim", build = "make", opts = {} }
```

`build = "make"` compiles the tree-sitter parser into `parser/conops.so` and downloads the
prebuilt `conops` binary for your platform from the latest
[release](https://github.com/sstoehrm/conops/releases).

### packer.nvim
```lua
use { "sstoehrm/conops.nvim", run = "make", config = function() require("conops").setup() end }
```

## Requirements

- Neovim 0.10+ (uses `vim.system`, `vim.diagnostic`, and native tree-sitter).
- A C compiler (`cc`) to build the parser.
- The `conops` binary — fetched by `build`, by `:ConopsInstall`, or supplied on your `PATH`.
  Highlighting works without it; diagnostics need it.

## What you get

- **Highlighting** — native tree-sitter, no `nvim-treesitter` dependency.
- **Diagnostics** — on `:w` / open, the buffer is checked with `conops check --json` and the
  results shown via `vim.diagnostic` (errors with their codes: `name-conflict`,
  `undefined-name`, `arity`, `enum-member`, `union-conformance`, `import-*`, …).

## Configuration

```lua
require("conops").setup({
  cmd = nil,       -- path to the conops binary (default: bundled bin/, then PATH)
  enabled = true,  -- run diagnostics on save / read
})
```

## Commands & health

- `:ConopsInstall` — (re)download the `conops` binary from the latest release.
- `:checkhealth conops` — reports parser and binary status.

## Maintainer notes

The tree-sitter parser is vendored under `src/` (generated from the grammar in the main
repo). After the grammar changes, refresh it with:

```sh
./scripts/sync-parser.sh /path/to/conops    # default: ../conops
```
