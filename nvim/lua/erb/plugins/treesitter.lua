return {
	{
		'nvim-treesitter/nvim-treesitter',
		version = false,
		build = ':TSUpdate',
		event = { 'VeryLazy' },
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
		keys = {
			{ '<c-space>', desc = 'Increment selection' },
			{ '<bs>',      desc = 'Decrement selection', mode = 'x' },
		},
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			ensure_installed = {
				'javascript',
				'http',
				'typescript',
				'lua',
				'query',
				'json',
				'rust',
			},
			endwise = {
				enable = true,
			},
			sync_install = false,
			auto_install = true,
			update_cwd = false,
			update_focused_line = {
				enabled = false,
				update_cwd = false,
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			autopairs = { enable = true },
			rainbow = { enable = true },
			indent = { enable = true },
			context_commentstring = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						['ii'] = '@conditional.inner',
						['ai'] = '@conditional.outer',
						['ia'] = '@parameter.inner',
						['aa'] = '@parameter.outer',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
						['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
					},
					selection_modes = {
						['@parameter.outer'] = 'v', -- charwise
						['@function.outer'] = 'V',  -- linewise
						['@class.outer'] = '<c-v>', -- blockwise
					},
				},
				move = {
					enable = true,
					goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
					goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
					goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
					goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
				},
				lsp_interop = {
					enable = true,
					border = 'none',
					floating_preview_opts = {},
				},
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			vim.keymap.set('n', '<M-h>', ':TSHighlightCapturesUnderCursor<CR>',
				{ silent = true, desc = 'Go to previous start' })
			if type(opts.ensure_installed) == 'table' then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
}
