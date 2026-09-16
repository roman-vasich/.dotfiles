---@module "lazy"
---@type LazySpec
local rustaceanvim = {
	"mrcjkb/rustaceanvim",
	version = '^9',
	lazy = false, -- This plugin is already lazy
	init = function()
		require("config.rustaceanvim")
	end,
}

return rustaceanvim
