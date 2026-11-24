local lsp_attach_augroup = vim.api.nvim_create_augroup("lsp.attach", { clear = true })

local highlight_yank_augroup = vim.api.nvim_create_augroup("user.highlight_yank", { clear = true })
local autosave_augroup = vim.api.nvim_create_augroup("user.autosave", { clear = true })
local treesitter_augroup = vim.api.nvim_create_augroup("user.treesitter", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_augroup,
	desc = "Highlight when yanking text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "InsertLeave", "BufModifiedSet" }, {
	group = autosave_augroup,
	desc = "Autosave writable buffers",
	pattern = "*",
	callback = function()
		if vim.bo.modified and vim.bo.buftype == "" and vim.fn.empty(vim.fn.expand("%:t")) == 0 then
			vim.cmd("update")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_augroup,
	pattern = "*",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

---@param bufn number
local function define_lsp_keymaps(bufn)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufn, desc = "LSP: " .. desc })
	end

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

	-- Find references for the word under your cursor.
	map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

	-- Fuzzy find all the symbols in your current workspace.
	--  Similar to document symbols, except searches over your entire project.
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

	map("<leader>a", vim.lsp.buf.code_action, "[C]ode [A]ction")

	map("K", vim.lsp.buf.hover, "Hover Documentation")

	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	map("<C-e>", function()
		vim.diagnostic.open_float({
			scope = "line",
		})
	end, "Open [E]rror diagnostic float")
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = lsp_attach_augroup,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		local bufn = args.buf
		define_lsp_keymaps(bufn)

		local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			local hu = "DiagnosticUnderline" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			vim.fn.sign_define(hu, { text = icon, texthl = hl, numhl = hl })
		end

		-- help :highlight, syntax [[ _vim script_ ]]
		vim.cmd([[
				hi DiagnosticVirtualTextError guibg=NONE
				hi DiagnosticVirtualTextWarn guibg=NONE
				hi DiagnosticVirtualTextHint guibg=NONE
				hi DiagnosticVirtualTextInfo guibg=NONE
				hi DiagnosticUnderlineError guisp='Red' gui=underline
				hi DiagnosticUnderlineWarn gui=underline
				hi DiagnosticUnderlineHint gui=underline
				hi DiagnosticUnderlineInfo gui=underline
				set termguicolors
			]])

		-- Floating diagnostic config
		---@type vim.diagnostic.Opts.Float
		local float_ops = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		}
		vim.diagnostic.config({
			float = float_ops,
			underline = true,
			virtual_text = {
				prefix = "",
				spacing = 1,
				severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
				source = true,
			},
			signs = true,
			update_in_insert = true,
		}, vim.lsp.diagnostic.get_namespace(client.id))

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
			callback = function()
				vim.diagnostic.open_float(float_ops)
			end,
		})

		-- Document highlight on cursor hold
		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufn, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufn,
				group = group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "LspDetach", "CursorMoved", "CursorMovedI" }, {
				buffer = bufn,
				group = group,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

-- Automatically trigger a check for file changes
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	pattern = "*",
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- Disable codediff cursorline highlight
vim.api.nvim_create_autocmd("User", {
	pattern = "CodeDiffOpen",
	callback = function(event)
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(event.data.tabpage)) do
			vim.wo[win].cursorline = false
		end
	end,
})
