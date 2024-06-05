local M = {}

function M.on_attach(client, bufnr)
	local opts = {}
	-- setup inlay hints toggle
	if client.server_capabilities.inlayHintProvider then
		vim.api.nvim_create_user_command('InlayOn', function()
			vim.lsp.inlay_hint(bufnr, true)
		end, {})
		vim.api.nvim_create_user_command('InlayOff', function()
			vim.lsp.inlay_hint(bufnr, false)
		end, {})
	end

	if client.supports_method 'textDocument/definition' then
		vim.keymap.set('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = true })
	end
	if client.supports_method 'textDocument/implementation' then
		vim.keymap.set('n', '<space>&', '<cmd>lua vim.lsp.buf.implementation()<CR>', { buffer = true })
	end
	if client.supports_method 'textDocument/definition' then
		vim.keymap.set(
			'n',
			'<Space>*',
			":lua require('lists').change_active('Quickfix')<CR>:lua vim.lsp.buf.references()<CR>",
			{ buffer = true }
		)
	end

	-- setup lspsage keybindings

	local status_ok, saga = pcall(require, 'lspsaga')
	if status_ok and client.name ~= "rust_analyzer" then
		vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<cr>', opts)
		vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<cr>', opts)
		vim.keymap.set('n', '<leader>gd', '<Cmd>Lspsaga finder<cr>', opts)
		vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<cr>', opts)
		vim.keymap.set('n', '<leader>r', '<Cmd>Lspsaga rename<cr>', opts)
		vim.keymap.set('n', '<leader>a', '<Cmd>Lspsaga code_action<cr>', opts)
	end

	-- ** ----------- **
	-- ** Formatting **
	-- ** ----------- **
	-- setup format only modifications if the server supports it
	vim.api.nvim_buf_create_user_command(bufnr, 'FormatModifications', function()
		local lsp_format_modifications = require 'lsp-format-modifications'
		lsp_format_modifications.format_modifications(client, bufnr)
	end, {})

	vim.api.nvim_create_user_command("Format", function(args)
		local range = nil
		if args.count ~= -1 then
			local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
			range = {
				start = { args.line1, 0 },
				["end"] = { args.line2, end_line:len() },
			}
		end
		require("conform").format({ async = true, lsp_fallback = true, range = range })
	end, { range = true })

	if client.supports_method 'textDocument/rangeFormatting' then
		vim.keymap.set('n', '<leader>f', function()
			require('lsp-format-modifications').format_modifications(client, bufnr)
		end)
	elseif client.supports_method 'textDocument/formatting' then
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end

	-- ** ----------- **
	-- ** End Formatting **
	-- ** ----------- **

	-- ** ----------- **
	-- ** Diagnostics **
	-- ** ----------- **
	require('twoslash-queries').attach(client, bufnr)
	_G.LspDiagnosticsPopupHandler = function()
		local current_cursor = vim.api.nvim_win_get_cursor(0)
		local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or { nil, nil }
		if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
			vim.w.lsp_diagnostics_last_cursor = current_cursor
			vim.diagnostic.open_float(0, { scope = 'cursor' })
		end
	end

	vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
		local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
		local bufnr = vim.api.nvim_get_current_buf()
		vim.diagnostic.reset(ns, bufnr)
		return true
	end

	local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
	for name, icon in pairs(signs) do
		name = 'DiagnosticSign' .. name
		vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
	end
	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true,
		float = { source = "always" },
	})

	vim.cmd [[
	augroup LSPDiagnosticsOnHover
	autocmd!
	autocmd CursorHold * lua _G.LspDiagnosticsPopupHandler()
	augroup END
]]
	vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
		callback = function()
			require('toggle_lsp_diagnostics').init { virtual_text = false }
		end,
	})
	-- ** ----------- **
	-- ** End Diagnostics **
	-- ** ----------- **
end

return M
