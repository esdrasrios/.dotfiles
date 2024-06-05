local util = require('erb.util.telescope')

local is_inside_work_tree = {}
local project_files = function()
	local opts = {}
	local cwd = vim.fn.getcwd()
	if is_inside_work_tree[cwd] == nil then
		vim.fn.system 'git rev-parse --is-inside-work-tree'
		is_inside_work_tree[cwd] = vim.v.shell_error == 0
	end

	if is_inside_work_tree[cwd] then
		util.telescope('git_files', opts)
	else
		util.telescope('find_files', opts)
	end
end

return {
	{
		'ahmedkhalf/project.nvim',
		config = function()
			require('project_nvim').setup {}
		end,
	},
	{
		'prochri/telescope-all-recent.nvim',
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"kkharji/sqlite.lua",
			-- optional, if using telescope for vim.ui.select
			"stevearc/dressing.nvim"
		},
		config = function()
			require('telescope-all-recent').setup {}
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope-live-grep-args.nvim' },
			{ 'nvim-telescope/telescope-fzf-native.nvim',    run = 'make' },
			{ 'nvim-telescope/telescope-ui-select.nvim' },
			{ 'nvim-telescope/telescope-project.nvim' },
			{ 'debugloop/telescope-undo.nvim' },
			{ 'SalOrak/whaler' },
		},
		keys = {
			{ "<leader><Cr>",     "<cmd>Telescope buffers show_all_buffers=true<cr>",                                                             desc = "Switch Buffer" },
			{ '<leader>?',        util.telescope('oldfiles'),                                                                                     desc = 'Find recently opened files' },
			{ '<leader>o',        util.telescope('buffers'),                                                                                      desc = 'Find existing buffers' },
			{ '<leader>pf',       util.telescope('find_files'),                                                                                   desc = '[pf] Find files' },
			{ '<leader>pl',       ':lua require("telescope.builtin").find_files({prompt_title="All -> PROJECT FILES", cwd="~/code/"}) <CR>', 	  desc = '[<leader>pl] Find files in code folder' },
			-- { '<leader>w',        util.telescope('live_grep_args_shortcuts.grep_word_under_cursor'),                                              desc = '[w] Live grep word under cursor' },
			{ '<C-f>',            ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",                                     desc = '[C-f] Live grep args' },
			{ '<C-l>',            ':lua require("telescope.builtin").live_grep({prompt_title="ALL -> LIVE GREP", cwd="~/code/"}) <CR>',           desc = '[c-l] Find files in code folder' },
			{ '<C-p>',            project_files,                                                                                                  desc = '[C-p] Find files in project' },
			{ '<leader><leader>', ":lua require'telescope'.extensions.projects.projects{}<CR>",                                                   desc = '[<leader><leader>] Find files in project' },
			{ '<leader>fp',       '<cmd>Telescope project<CR>',                                                                                   desc = 'Find projects' },
			{ '<leader>,',        util.telescope('resume'),                                                                                       desc = 'Resume Telescope' },
			{ '<leader>u',        '<cmd>Telescope undo<cr>',                                                                                      desc = 'Find undo history' },
			-- { '<leader>fw',       util.extension('whaler.whaler'),                                                                                desc = '[pf] Find files' },
			-- { '<leader>ps', function() builtin.grep_string { search = vim.fn.input 'Grep > ' } end,  desc = '[ps] Grep string' },
		},
		opts = function()
			local telescope = require('telescope')
			local actions = require 'telescope.actions'
			local lga_actions = require 'telescope-live-grep-args.actions'
			local project_actions = require 'telescope._extensions.project.actions'
			require("telescope").load_extension("rest")
			require('telescope').load_extension 'projects'
			require('telescope').load_extension 'live_grep_args'
			require('telescope').load_extension 'undo'
			require('telescope').load_extension 'whaler'
			local builtin = require 'telescope.builtin'
			local live_grep_args_shortcuts = require 'telescope-live-grep-args.shortcuts'

			vim.keymap.set("n", "<leader>fw", telescope.extensions.whaler.whaler)
			vim.keymap.set(
				'n',
				'<leader>w',
				live_grep_args_shortcuts.grep_word_under_cursor,
				{ desc = '[w] Live grep word under cursor' }
			)
			vim.keymap.set("n", "<leader>wn", function()
				local w = telescope.extensions.whaler.whaler
				w({
					auto_file_explorer = true,
					auto_cwd = false,
					file_explorer_config = {
						plugin_name = "telescope",
						command = "Telescope find_files",
						prefix_dir = " cwd=",
					},
					theme = {
						previewer = false,
					},
				})
			end)
			vim.keymap.set('n', '<leader>/', function()
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, {
				desc = '[/] Fuzzily search in current buffer',
			})

			return {
				defaults = {
					file_ignore_patterns = { 'node_modules/.*', 'dist/.*', '*.test.js', '*.test.ts' },
					prompt_prefix = "  ",
					selection_caret = '  ',
					entry_prefix = '  ',
					initial_mode = 'insert',
					selection_strategy = 'reset',
					sorting_strategy = 'descending',
					layout_strategy = 'horizontal',
					layout_config = {
						horizontal = {
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = true,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					file_sorter = require('telescope.sorters').get_fuzzy_file,
					generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
					winblend = 0,
					color_devicons = true,
					use_less = true,
					set_env = { ['COLORTERM'] = 'truecolor' },
					file_previewer = require('telescope.previewers').vim_buffer_cat.new,
					grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
					qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
					buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
					mappings = {
						i = {
							['<C-j>'] = actions.move_selection_next,
							['<C-k>'] = actions.move_selection_previous,
							['<s-up>'] = actions.cycle_history_next,
							['<s-down>'] = actions.cycle_history_prev,
							['<esc>'] = actions.close,
						},
					},
					path_display = function(_, path)
						local filename = path:gsub(vim.pesc(vim.loop.cwd()) .. '/', '')
							:gsub(vim.pesc(vim.fn.expand '$HOME'), '~')
						local tail = require('telescope.utils').path_tail(filename)
						return string.format('%s  —  %s', tail, filename)
					end,
				},
				extensions = {
					project = {
						base_dirs = {
							{ '~/code', max_depth = 2 }
						},
						sync_with_nvim_tree = false,
						hidden_files = true,
						theme = 'dropdown',
						order_by = 'recent',
						search_by = 'title',
						on_project_selected = function(prompt_bufnr)
							project_actions.change_working_directory(prompt_bufnr, false)
							require('harpoon.ui').nav_file(1)
						end,
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = 'smart_case',
					},
					live_grep_args = {
						auto_quoting = true,
						path_display = { 'shorten' },
						mappings = {
							i = {
								['<C-b>'] = lga_actions.quote_prompt(),
								['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
							},
						},
					},
					whaler = {
						directories = { "/Users/esdrasriosbaia/code/", alias = "yet" },
						oneoff_directories = { "/Users/esdrasriosbaia/.config/nvim" },
					},
				},
			}
		end,
	},
}
