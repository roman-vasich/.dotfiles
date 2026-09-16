---@module "lazy"
---@type LazySpec
local plugin = {
	enabled = true,
	-- None-ls/null-ls integrates into vim.lsp to provide formatting/linting.
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	keys = {},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			-- debug = true,
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- JSON/Markdown
				null_ls.builtins.formatting.prettierd.with({
					filetypes = { "json", "markdown" },
				}),

				-- YAMLs
				null_ls.builtins.diagnostics.actionlint,
				null_ls.builtins.diagnostics.yamllint.with({
					extra_args = {
						"-d",
						"{extends: default, rules: {line-length: {max: 180}}}",
					},
				}),
				null_ls.builtins.formatting.yamlfmt,
				null_ls.builtins.diagnostics.kube_linter,

				-- Go
				null_ls.builtins.diagnostics.golangci_lint,

				-- C/C++
				-- Linting is embedded into clangd via clang-tidy
				-- null_ls.builtins.diagnostics.cpplint,
				null_ls.builtins.diagnostics.cppcheck,
				null_ls.builtins.formatting.clang_format,

				-- SQL
				null_ls.builtins.formatting.sqlfluff.with({
					extra_args = { "--dialect", "postgres" },
				}),

				-- Dockerfile
				null_ls.builtins.diagnostics.hadolint,

				-- Terraform
				null_ls.builtins.formatting.terraform_fmt,

				-- Shell
				-- null_ls.builtins.code_actions.shellcheck,
			},
		})
	end,
}

return plugin
