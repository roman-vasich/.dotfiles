---@module "lazy"
---@module "Comment"
---@type LazySpec
local c = {
	"numToStr/Comment.nvim",
	---@type CommentConfig
	opts = {
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
	},
}

return c
