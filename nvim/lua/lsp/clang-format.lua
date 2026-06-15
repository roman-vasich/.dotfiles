require("vim.lsp")

--- @type vim.lsp.ClientConfig
local config = {
	cmd = { "clang-format" },
	root_markers = { "CMake", "Makefile", "Make" },
	filetypes = { "c", "cpp" },
	settings = {},
}

return config
