require("vim.lsp")

---@type vim.lsp.ClientConfig
local config = {
	cmd = { "tflint", "--langserver" },
	filetypes = { "terraform" },
	root_markers = { ".terraform", ".git", ".tflint.hcl" },
}

return config
