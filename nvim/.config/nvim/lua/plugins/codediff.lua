---@module "lazy"
---@type LazySpec
local plugin = {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	opts = {
		diff = {
			highlight_added_deleted_files = true,
		},
		explorer = {
			view_mode = "tree",
			untracked = "no", -- Options: "all" (default), "normal", or "no"
		},
		highlights = {
			-- Line-level: muted tints of Dracula green/red
			line_insert = "#24402f",
			line_delete = "#472631",
			-- Character-level: brighter tints of the same hues
			char_insert = "#2f6b45",
			char_delete = "#7a3340",
		},
	},
}

return plugin
