local config = function(_, _)
	local augroup = vim.api.nvim_create_augroup("lsp.attach", { clear = true })
	vim.api.nvim_create_autocmd({ "LspAttach" }, {
		group = augroup,
		callback = function(event)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
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

			-- Rename the variable under your cursor.
			--  Most Language Servers support renaming across files, etc.
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			map("<leader>a", vim.lsp.buf.code_action, "[C]ode [A]ction")

			map("K", vim.lsp.buf.hover, "Hover Documentation")
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			map("<C-e>", function()
				vim.diagnostic.open_float({
					scope = "line",
				})
			end, "Open [E]rror diagnostic float")

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client then
				local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
				for type, icon in pairs(signs) do
					local hl = "DiagnosticSign" .. type
					local hu = "DiagnosticUnderline" .. type
					vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
				end

				-- help :highlight, syntax [[ _vim script_ ]]
				vim.cmd([[
						hi DiagnosticVirtualTextError guibg=NONE
						hi DiagnosticVirtualTextWarn guibg=NONE
						hi DiagnosticVirtualTextHint guibg=NONE
						hi DiagnosticVirtualTextInfo guibg=NONE
						hi DiagnosticUnderlineError guisp='Red' gui=underline
						hi DiagnosticUnderlineWarn gui=NONE
						hi DiagnosticUnderlineHint gui=NONE
						hi DiagnosticUnderlineInfo gui=NONE
						set termguicolors
					]])

				---@type vim.diagnostic.Opts.Float
				float_ops = {
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
					signs,
					update_in_insert = true,
				}, vim.lsp.diagnostic.get_namespace(client.id))

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
					callback = function()
						vim.diagnostic.open_float(float_ops)
					end,
				})
			end

			if client and client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})
end

return config
