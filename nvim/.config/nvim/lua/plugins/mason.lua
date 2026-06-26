---@module "lazy"
---@type LazySpec
local c = {
	"williamboman/mason.nvim",
	dependencies = {
		"jay-babu/mason-nvim-dap.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},

	config = require("config.mason"),
}

return c
