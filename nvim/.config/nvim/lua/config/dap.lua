---@param opts table
local config = function(_, opts)
	local dap = require("dap")
	local ui = require("dapui")

	require("dapui").setup(opts)
	require("dap-go").setup(vim.tbl_deep_extend("keep", {
		mappings = {
			edit = "",
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "",
			repl = "r",
			toggle = "",
		},
	}, opts))

	require("nvim-dap-virtual-text").setup(vim.tbl_deep_extend("keep", {
		-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
		display_callback = function(variable)
			local name = string.lower(variable.name)
			local value = string.lower(variable.value)
			if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
				return "*****"
			end

			if #variable.value > 15 then
				return " " .. string.sub(variable.value, 1, 15) .. "... "
			end

			return " " .. variable.value
		end,
	}, opts))

	vim.keymap.set("n", "<space>b", dap.toggle_breakpoint, { desc = "Set DAP breakpoint " })
	vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "Run DAP to the current line" })
	vim.keymap.set("n", "<space>?", function()
		require("dapui").eval(nil, { enter = true })
	end, { desc = "DAP Eval under cursor" })
	vim.keymap.set("n", "<space>dc", dap.continue, { desc = "[D]AP [C]ontinue" })
	vim.keymap.set("n", "<space>di", dap.step_into, { desc = "[D]AP Step [I]nto" })
	vim.keymap.set("n", "<space>do", dap.step_over, { desc = "[D]AP Step [O]over" })
	vim.keymap.set("n", "<space>du", dap.step_out, { desc = "[D]AP Step Out" })
	vim.keymap.set("n", "<space>db", dap.step_back, { desc = "[D]AP Step [B]ack" })
	vim.keymap.set("n", "<space>dr", dap.restart, { desc = "[D]AP Step [R]estart" })

	dap.listeners.before.attach.dapui_config = function()
		ui.open()
	end

	dap.listeners.before.launch.dapui_config = function()
		ui.open()
	end

	dap.listeners.before.event_terminated.dapui_config = function()
		ui.close()
	end

	dap.listeners.before.event_exited.dapui_config = function()
		ui.close()
	end

	dap.adapters.codelldb = {
		type = "executable",
		command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

		-- On windows you may have to uncomment this:
		-- detached = false,
	}

	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp
end

return config
