---@module 'mason-tool-installer'
---@type MasonToolEntry[]
local ensure_installed = {
	-- Lua
	"lua_ls",
	"stylua",

	-- Yamls/JSONs
	"actionlint",
	"yamllint",
	"yamlfmt",
	"kube-linter",

	-- Go
	"gopls",
	"golangci-lint",
	-- Debugger for Go
	"delve",

	-- C/C++
	"clangd",
	"neocmakelsp",

	-- Python
	"ruff",

	-- SQL
	"sqlfluff",

	-- Sh/Bash
	"shellcheck",
	"bashls",

	-- Debugger
	"codelldb",

	-- Dockerfile
	"hadolint",

	-- Terraform
	"terraform-ls",
	"terraform",
	"tflint",

	-- JSON, Markdown
	"prettierd",

	-- TypeScript
	"ts_ls",

	"pylsp",

	"misspell",
}

---@module 'lazy'
---@type LazySpec
local c = {
	{
		"mason-org/mason.nvim",
		---@module 'mason'
		---@type MasonSettings
		opts = {
			pip = {
				upgrade_pip = true,
			},
		},
		dependencies = {
			"jay-babu/mason-nvim-dap.nvim",
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		---@module 'mason-lspconfig'
		---@type MasonLspconfigSettings
		opts = {
			automatic_enable = true,
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		-- Convenient plugin to install all available Mason
		-- tools.
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		---@module 'mason-tool-installer'
		---@type MasonToolInstallerSettings
		opts = {
			ensure_installed = ensure_installed,
			["mason-lspconfig"] = true,
			-- Not installed. Perhaps worth considering later.
			["mason-null-ls"] = false,
			["mason-nvim-dap"] = true,
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
}

return c
