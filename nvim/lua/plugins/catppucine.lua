local flavor = "mocha"
function vim.g:set_flavor(new_flavor)
	flavor = new_flavor
end

---@module "lazy"
---@type LazySpec
local catppuccin = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	init = function(_)
		require("catppuccin").setup({
			flavour = flavor,
			default_integrations = true,
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}

return catppuccin
