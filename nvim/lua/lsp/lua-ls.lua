require("vim.lsp")

local root_markets = {
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

local function is_subpath(path, root)
	path = vim.fs.normalize(path)
	root = vim.fs.normalize(root)

	return path == root or vim.startswith(path, root .. "/")
end

--- @type vim.lsp.ClientConfig
local config = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = function(bufnr, on_dir)
		-- nvim config usually lies under ~/.config, where ~/config/.git is places,
		-- to avoid placing root on ~/.config it is handled manually.
		local config = vim.fn.stdpath("config")
		local cwd = vim.fn.getcwd()
		local fname = vim.api.nvim_buf_get_name(bufnr)

		if is_subpath(cwd, config) and is_subpath(fname, config) then
			on_dir(config)
			return
		end

		on_dir(vim.fs.root(bufnr, root_markets))
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
					-- [require("lazy.core.config").options.root .. "/"] = true,
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
