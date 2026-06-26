local highlight_yank = vim.api.nvim_create_augroup("user.highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank,
	desc = "Highlight when yanking text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

local autosave = vim.api.nvim_create_augroup("user.autosave", { clear = true })
vim.api.nvim_create_autocmd({ "VimLeave", "InsertLeave", "BufModifiedSet" }, {
	group = autosave,
	desc = "Autosave writable buffers",
	pattern = "*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.api.nvim_buf_get_name(bufnr) == "" then
			return
		end

		if vim.bo[bufnr].readonly or (vim.bo[bufnr].buftype ~= "acwrite" and vim.bo[bufnr].buftype ~= "") then
			return
		end

		vim.api.nvim_win_call(0, function()
			vim.api.nvim_command("silent write")
		end)
	end,
})

local filetypes = vim.api.nvim_create_augroup("user.filetypes", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = filetypes,
	pattern = "docker-compose.yml",
	command = "set filetype=yaml.docker-compose",
})
