---@module "lazy"
---@type LazySpec
local c = {
	"numToStr/Comment.nvim",
	config = function(_, opts)
		---@type CommentConfig
		local config = {
			ignore = "^$",
			sticky = true,
			-- Some linters require space
			padding = true,
			toggler = {
				line = "<C-_>",
			},
			opleader = {
				line = "<C-_>",
			},
		}

		require("Comment").setup(vim.tbl_deep_extend("keep", config, opts))
	end,
}

return c
