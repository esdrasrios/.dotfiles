require('erb.plugins.lsp')
require('erb.plugins.lsp.lspsaga')

return {
	{ 'b3nj5m1n/kommentary' },
	{ 'nvim-lua/plenary.nvim' },
	{ 'folke/trouble.nvim',   opts = {} },
	-- UTILS
	{
		'windwp/nvim-autopairs',
		enabled = false,
		event = 'InsertEnter',
		config = true,
	},
	{ 'echasnovski/mini.splitjoin', opts = {} },
	{ 'tpope/vim-surround' },
	{
		'j-hui/fidget.nvim',
		enabled = false,
		opts = {
			progress = {
				suppress_on_insert = true,
			},
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	},
	{
		'folke/flash.nvim',
		event = 'VeryLazy',
		keys = {
			{
				's',
				mode = { 'n', 'x', 'o' },
				function()
					require('flash').jump()
				end,
				desc = 'Flash',
			},
			{
				'S',
				mode = { 'n', 'x', 'o' },
				function()
					require('flash').treesitter()
				end,
				desc = 'Flash Treesitter',
			},
			{
				'r',
				mode = 'o',
				function()
					require('flash').remote()
				end,
				desc = 'Remote Flash',
			},
			{
				'R',
				mode = { 'o', 'x' },
				function()
					require('flash').treesitter_search()
				end,
				desc = 'Treesitter Search',
			},
			{
				'<c-s>',
				mode = { 'c' },
				function()
					require('flash').toggle()
				end,
				desc = 'Toggle Flash Search',
			},
		},
		opts = {
			label = { after = { 0, 0 } },
			search = {
				mode = function(str)
					return '\\<' .. str
				end,
			},
			modes = {
				search = {
					enabled = false,
				},
				multi_line = false,
				char = {
					keys = { 'f', 'F', ';', ',' },
				},
			},
		},
	},
	{
		'theprimeagen/refactoring.nvim',
		opts = function()
			vim.keymap.set('v', '<leader>rf', [[<esc><cmd>lua require('refactoring').refactor('Extract Function')<cr>]])
			vim.keymap.set('v', '<leader>rv', [[<esc><cmd>lua require('refactoring').refactor('Extract Variable')<cr>]])
			vim.keymap.set('v', '<leader>ri', [[<esc><cmd>lua require('refactoring').refactor('Inline Variable')<cr>]])
			vim.keymap.set('n', '<leader>ri', [[<cmd>lua require('refactoring').refactor('Inline Variable')<cr>]])

			vim.keymap.set('v', '<leader>rr', ":lua require('refactoring').select_refactor()<CR>")
			vim.keymap.set('n', '<leader>rr', ":lua require('refactoring').select_refactor()<CR>")
		end,
	},
	{
		'ThePrimeagen/harpoon',
		opts = function()
			local mark = require 'harpoon.mark'
			local ui = require 'harpoon.ui'

			vim.keymap.set('n', '<leader>a', mark.add_file)
			vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

			vim.keymap.set('n', '<C-h>', function()
				ui.nav_file(1)
			end)
			vim.keymap.set('n', '<C-t>', function()
				ui.nav_file(2)
			end)
			vim.keymap.set('n', '<C-n>', function()
				ui.nav_file(3)
			end)
			vim.keymap.set('n', '<C-s>', function()
				ui.nav_file(4)
			end)
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		enabled = false,
		event = { "UIEnter" },
		config = function()
			require("hlchunk").setup({
				indent = {
					style = "#898989",
				},
				blank = {
					enable = false,
					chars = {
						"",
					},
					style = {
						vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
					},
				},
				line_num = {
					enable = false,
					style = "#e6ca8d",
				},
				chunk = {
					enable = true,

					style = "#d6d6dd",
					chars = {
						horizontal_line = "̈̈̈̈",
						vertical_line = "│",
						left_top = "",
						left_bottom = "",
						right_arrow = "",
					},
				}
			})
		end
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'BufWinEnter',
		opts = {
			scope = { enabled = false },
			indent = {
				char = '▏',
				tab_char = '▏',
			},
			exclude = {
				filetypes = {
					'help',
					'markdown',
					'gitcommit',
					'packer',
				},
				buftypes = { 'terminal', 'nofile' },
			},
		},
		config = function(_, opts)
			require('ibl').setup(opts)

			local hooks = require 'ibl.hooks'
			hooks.register(
				hooks.type.WHITESPACE,
				hooks.builtin.hide_first_space_indent_level
			)
		end,
	},
	{
		'stevearc/dressing.nvim',
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require('lazy').load { plugins = { 'dressing.nvim' } }
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require('lazy').load { plugins = { 'dressing.nvim' } }
				return vim.ui.input(...)
			end
		end,
	},
	-- Lazy??
	{ 'xiyaowong/transparent.nvim' },
	{
		'rest-nvim/rest.nvim',
		ft = 'http',
		config = function()
			require('rest-nvim').setup({
				result_split_in_place = true,
				jump_to_request = false,
				stay_in_current_window_after_split = true,

			})
			vim.api.nvim_create_user_command('Rest', function()
				require('rest-nvim').run()
			end, {})
		end,
	},
	{ 'mg979/vim-visual-multi' },
	{ 'sQVe/sort.nvim' },
	{
		'norcalli/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
		end,
	},
	-- TO CHECK
	{
		'm-demare/hlargs.nvim',
		config = function()
			require('hlargs').setup()
		end
	},
	{ 'williamboman/mason.nvim' },
	{ 'neovim/nvim-lspconfig' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'onsails/lspkind.nvim' },
	{
		'dense-analysis/ale',
		enabled = false,
	},
	{
		"folke/neodev.nvim",
		-- enabled = false,
		opts = { debug = true, },
	},
}
