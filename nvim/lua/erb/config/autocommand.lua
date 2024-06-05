local group = vim.api.nvim_create_augroup('Setup', {})
local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_user_command('ToggleColorcolumn', function()
	vim.wo.colorcolumn = vim.wo.colorcolumn == '' and '80' or ''
end, { nargs = 0 })

autocmd('TextYankPost', {
	group = group,
	callback = function()
		require('vim.highlight').on_yank { higroup = 'Substitute', timeout = 200 }
	end,
})
autocmd({ 'InsertLeave', 'WinEnter' }, { command = 'set cursorline', group = group })
autocmd({ 'InsertEnter', 'WinLeave' }, { command = 'set nocursorline', group = group })
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
	group = group,
	command = [[silent! if mode() != 'c' && !bufexists("[Command Line]") | checktime | endif]],
})

autocmd('FileChangedShellPost', {
	group = group,
	command = [[echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]],
})

autocmd('BufReadPost', {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})
-- auto restore cursor position
autocmd("BufReadPost", {
	pattern = { "*" },
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			---@diagnostic disable-next-line: param-type-mismatch
			vim.fn.setpos(".", vim.fn.getpos("'\""))
			vim.cmd("silent! foldopen")
		end
	end,
})

autocmd('FileType', {
	group = group,
	pattern = {
		'PlenaryTestPopup',
		'help',
		'man',
		'lspinfo',
		'checkhealth',
		'qf',
		'noice',
		'notify',
		'fugitive',
		'fugitiveblame',
		'startuptime',
		'tsplayground',
		'httpResult'
	},
	callback = function(event)
		-- vim.notify("FileType File::" .. vim.inspect(event.file) .. " --->  Match Pattern:" .. vim.inspect(event.match))
		vim.bo[event.buf].buflisted = false
		vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
	end,
})

autocmd({ 'BufEnter' }, {
	pattern = { '*' },
	command = 'normal zx zR',
})


autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }


		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>vca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>ff', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
