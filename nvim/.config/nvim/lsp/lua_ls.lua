require("vim.lsp")

local root_markers = {
	{
		".emmyrc.json",
		".luarc.json",
		".luarc.jsonc",
	},
	{
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
	},
	{ ".git" },
}

---@param path string
---@param root string
---@return boolean
local function is_subpath(path, root)
	path = vim.fs.normalize(path)
	root = vim.fs.normalize(root)

	return path == root or vim.startswith(path, root .. "/")
end

---@type vim.lsp.ClientConfig
local config = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = function(bufnr, on_dir)
		local config_path = vim.fn.stdpath("config")
		local cwd = vim.fn.getcwd()
		local fname = vim.api.nvim_buf_get_name(bufnr)

		if is_subpath(cwd, config_path) and is_subpath(fname, config_path) then
			on_dir(config_path)
			return
		end

		on_dir(vim.fs.root(bufnr, root_markers))
	end,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
				disable = { "missing-fields" },
			},
			workspace = {
				library = {
					vim.fn.stdpath("config"),
				},
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
