require("vim.lsp")

---@type vim.lsp.ClientConfig
local config = {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "tf", "terraform-vars" },
	root_markers = { ".terraform", ".git" },
}

return config
