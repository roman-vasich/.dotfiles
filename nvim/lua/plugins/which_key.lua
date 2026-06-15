---@module "lazy"
---@type LazySpec
local which_key = {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function(_, opts)
		local which_key = require("which-key")
		which_key.setup(vim.tbl_deep_extend("keep", { notify = false }, opts))

		-- Document existing key chains
		local wk = require("which-key")
		wk.add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>w", group = "[W]orkspace" },
		})
	end,
}
return which_key
