require("vim.lsp")

---@type vim.lsp.ClientConfig
local config = {
	cmd = { "pylsp" },
	filetypes = { "python" },
	settings = {
		pylsp = {
			plugins = {
				-- Managed by null-ls
				ruff = { enabled = true },
				jedi_completion = { enabled = true },
				jedi_definition = { enabled = true },
				jedi_hover = { enabled = true },
				jedi_references = { enabled = true },
				jedi_signature_help = { enabled = true },
				jedi_symbols = { enabled = true },
			},
		},
	},
	before_init = function(params, config)
		local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
		if venv_path then
			config.settings.pylsp.plugins.jedi = {
				environment = venv_path,
			}
		end
	end,
}

return config
