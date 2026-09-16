require("vim.lsp")

--- @type vim.lsp.ClientConfig
local config = {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	root_markers = { "CMake", "Make" },
	filetypes = { "c", "cpp" },
	settings = {},
}

return config
