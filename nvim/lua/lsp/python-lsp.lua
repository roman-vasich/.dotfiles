require("vim.lsp")

--- @type vim.lsp.ClientConfig
local config = {
	cmd = { "pylsp" },
	filetypes = { "py", "python" },
	settings = {
		pylsp = {
			plugins = {
				-- Managed by null-ls
				ruff = { enabled = false },
				isort = { enable = false },
				black = { enabled = false },
				pyflakes = { enabled = false },
				pycodestyle = { enabled = false },
				autopep8 = { enabled = false },
				yapf = { enabled = false },
				mccabe = { enabled = false },
				pylsp_mypy = { enabled = false },
				pylsp_isort = { enabled = false },
				pylint = { enabled = false },
				flake8 = { enabled = true },
				pydocstyle = { enabled = true },
				rope_completion = { enabled = true },
				jedi_completion = { enabled = true },
				jedi_definition = { enabled = true },
				jedi_hover = { enabled = true },
				jedi_references = { enabled = true },
				jedi_signature_help = { enabled = true },
				jedi_symbols = { enabled = true },
			},
		},
	},
}

return config
