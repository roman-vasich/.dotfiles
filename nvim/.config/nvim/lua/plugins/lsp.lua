---@module "lazy"
---@type LazySpec
local lsp = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		{
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				opts.sources = opts.sources or {}
				table.insert(opts.sources, {
					name = "lazydev",
					group_index = 0,
				})
			end,
		},
	},
	config = require("config.lsp"),
	keys = {
		{
			"<leader>f",
			function()
				vim.lsp.buf.format()
			end,
			mode = "n",
			desc = "[F]ormat buffer",
		},
	},
}

return lsp
