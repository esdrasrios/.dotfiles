return {
	{
		'lewis6991/gitsigns.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			signs = {
				add = {
					text = '▎', -- ▍
					show_count = true,
				},
				change = {
					text = '▎',
					show_count = true,
				},
				delete = {
					text = '▎',
					show_count = true,
				},
				topdelete = {
					text = '‾',
					show_count = true,
				},
				changedelete = {
					text = '▎',
					show_count = true,
				},
				untracked = {
					text = '▍', -- ▋▎┊┆╷
				},
			},
			count_chars = {
				[1] = '',
				[2] = '₂',
				[3] = '₃',
				[4] = '₄',
				[5] = '₅',
				[6] = '₆',
				[7] = '₇',
				[8] = '₈',
				[9] = '₉',
				['+'] = '₊',
			},
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = { interval = 1000, follow_files = true },
			attach_to_untracked = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = true,
			},
			current_line_blame_formatter_opts = {
				relative_time = false,
			},
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000,
			preview_config = {
				-- Options passed to nvim_open_win
				border = 'single',
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local keymap = function(lhs, rhs, desc, opts)
					opts = opts or {}
					opts.desc = desc
					opts.buffer = bufnr
					vim.keymap.set('n', lhs, rhs, opts)
				end

				keymap(']g', function()
					if vim.wo.diff then
						return ']g'
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return '<Ignore>'
				end, 'Next hunk', { expr = true })
				keymap('[g', function()
					if vim.wo.diff then
						return '[g'
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return '<Ignore>'
				end, 'Previous hunk', { expr = true })
				keymap('<leader>gB', gs.blame_line, 'Blame line')
				keymap('<leader>gs', gs.stage_hunk, 'Stage hunk')
				keymap('<leader>gr', gs.reset_hunk, 'Reset hunk')
				keymap('<leader>gS', gs.stage_buffer, 'Stage all hunks in buffer')
				keymap('<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
				keymap('<leader>gR', gs.reset_buffer, 'Reset hunks in buffer')
				keymap('<leader>gp', gs.preview_hunk, 'Preview hunk')
				keymap('<leader>xh', function()
					gs.setqflist 'all'
				end, 'Hunks')

				--[[ -- Actions
					map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk)
					map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk)
					map('n', '<leader>hS', gs.stage_buffer)
					map('n', '<leader>hu', gs.undo_stage_hunk)
					map('n', '<leader>hR', gs.reset_buffer)
					map('n', '<leader>hp', gs.preview_hunk)
					map('n', '<leader>hb', gs.toggle_current_line_blame)
					map('n', '<leader>hd', gs.diffthis)
					map('n', '<leader>hD', function()
						gs.diffthis '~'
					end)

					-- Text object
					map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>') ]]

				-- Add group prefix for which-key.
				require('which-key').register {
					['<leader>g'] = { name = '+git' },
				}
			end,
		},
	},
	{
		'NeogitOrg/neogit',
		keys = {
			{
				'<leader>g',
				function()
					require('neogit').open()
				end,
			},
			{
				'<leader>c',
				function()
					require('neogit').open { 'commit' }
				end,
			},
		},
		opts = {
			disable_hint = true,
			disable_commit_confirmation = true,
			signs = {
				section = { '', '' },
				item = { '', '' },
				hunk = { '', '' },
			},
			integrations = {
				diffview = true,
			},
		},
	},
	{
		'akinsho/git-conflict.nvim',
		-- event = 'VeryLazy',
		keys = {
			{ '<leader>co', '<Plug>(git-conflict-ours)' },
			{ '<leader>ct', '<Plug>(git-conflict-theirs)' },
			{ '<leader>cb', '<Plug>(git-conflict-both)' },
			{ '<leader>c0', '<Plug>(git-conflict-none)' },
			{ '[x',         '<Plug>(git-conflict-prev-conflict)' },
			{ ']x',         '<Plug>(git-conflict-next-conflict)' },
		},
		opts = { default_mappings = false },
		config = function(_, opts)
			require('git-conflict').setup(opts)
		end,
	},
	{
		'sindrets/diffview.nvim',
		cmd = { 'DiffviewFileOpen', 'DiffviewFileHistory' },
		opts = { enhanced_diff_hl = true },
	},
	{
		'pwntester/octo.nvim',
		cmd = 'Octo',
		keys = {
			{
				'<leader>op',
				function()
					local url =
						vim.fn.system 'gh pr view --json url --jq .url 2>/dev/null'
					if url then
						vim.notify(url)
						local cmd = string.format('Octo %s', url)
						vim.cmd(cmd)
					else
						vim.cmd 'Octo pr list'
					end
				end,
			},
			{ '<leader>oi', '<cmd>Octo issue list<cr>' },
		},
		opts = { date_format = '%Y %b %d %H:%M' },
	},
	{
		'topaxi/gh-actions.nvim',
		cmd = 'GhActions',
		build = 'make',
		dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
		opts = {},
		config = function(_, opts)
			require('gh-actions').setup(opts)
		end,
	},
	{
		'ruifm/gitlinker.nvim',
		keys = {
			{
				'<leader>ho',
				function()
					require('gitlinker').get_buf_range_url('n', {
						action_callback = require('gitlinker.actions').open_in_browser,
					})
				end,
			},
			{
				'<leader>ho',
				function()
					require('gitlinker').get_buf_range_url('v', {
						action_callback = require('gitlinker.actions').open_in_browser,
					})
				end,
				mode = 'v',
			},
		},
		config = { mappings = nil },
	},
}
