---@param opts table
local c = function(_, opts)
	---@type MasonSettings|table
	require("mason").setup(vim.tbl_deep_extend("keep", {}, opts))
	---@module "mason"
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
		"delve",

		-- C/C++
		"clangd",
		"cpplint",
		"mbake",
		"cmake",
		"cmakelint",

		-- Python
		"pylsp",
		"ruff",
		"black",
		"isort",
		"flake8",

		-- SQL
		"sqlfluff",

		-- Sh/Bash
		"shellcheck",
		"bashls",

		-- Debugger
		"codelldb",

		-- Dockerfile
		"hadolint",

		"typos_lsp",
		-- JSON, Markdown
		"prettierd",

		-- TypeScript
		"ts_ls",
	}

	require("mason-tool-installer").setup({
		ensure_installed = ensure_installed,
		auto_update = false,
		run_on_start = true,
	})

	-- Translate `neovim/nvim-lspconfig` to Mason and automatically enable
	require("mason-lspconfig").setup({ automatic_installation = true })
	vim.lsp.config("lua_ls", require("lsp.lua-ls"))
	vim.lsp.config("gopls", require("lsp.gopls"))
	vim.lsp.config("pylsp", require("lsp.python-lsp"))

	local ok_esp32, esp32 = pcall(require, "esp32")
	if ok_esp32 then
		vim.lsp.config("clangd", esp32.lsp_config())
	else
		vim.lsp.config("clangd", require("lsp.clangd"))
	end
end

return c
