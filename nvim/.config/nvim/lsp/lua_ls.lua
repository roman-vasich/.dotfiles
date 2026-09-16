---@type vim.lsp.ClientConfig
local config = {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
				disable = { "missing-fields" },
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "tab",
					indent_size = "4",
				},
			},
		},
	},
}

return config
