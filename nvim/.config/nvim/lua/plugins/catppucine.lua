---@module "lazy"
---@type LazySpec
local plugin = {
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("dracula").setup({
				theme = "dracula-soft",
				transparent_bg = true,
				italic_comment = true,
			})
		end,
	},
}

return plugin
