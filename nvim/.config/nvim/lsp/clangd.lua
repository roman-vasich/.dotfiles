require("vim.lsp")

--- @type vim.lsp.ClientConfig
local config = {
	cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
	root_markers = { "CMake", "Make" },
	filetypes = { "c", "cpp" },
	settings = {},
}

return config
