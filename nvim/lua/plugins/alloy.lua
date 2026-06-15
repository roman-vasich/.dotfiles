local alloy = {
	"grafana/vim-alloy",
	ft = "alloy",
	init = function()
		vim.filetype.add({
			extension = {
				alloy = "alloy",
			},
		})
	end,
}

return alloy
