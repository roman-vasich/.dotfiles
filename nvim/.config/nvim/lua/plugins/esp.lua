local esp = {
	{
		"Aietes/esp32.nvim",
		opts = {
			clangd_args = {
				"--query-driver=**/*xtensa-esp32*-elf-gcc",
			},
			build_dir = "build",
		},
		keys = {
			{
				"<leader>em",
				function()
					require("esp32").pick("monitor")
				end,
				desc = "ESP32: Pick & Monitor",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers = opts.servers or {}
			opts.servers.clangd = require("esp32").lsp_config()
			return opts
		end,
	},
}

return esp
