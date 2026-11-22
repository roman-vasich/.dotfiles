---@module "lazy"
---@module "uv"
---@type LazySpec
return {
	"benomahony/uv.nvim",
	ft = { "python" },
	main = "uv",
	---@type UVConfig
	opts = {
		-- Set environment variables for the current Neovim instance under vim.env.VIRTUAL_ENV
		auto_activate_venv = true,
		notify_activate_venv = true,
		picker_integration = true,
	},
}
