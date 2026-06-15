---@module "lazy"
---@type LazySpec
local rustaceanvim = {
	"mrcjkb/rustaceanvim",
	version = "5^",
	lazy = false, -- This plugin is already lazy
	init = function()
		require("config.rustacceanvim")
	end,
}

return rustaceanvim
