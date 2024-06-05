return {
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-path',
			'f3fora/cmp-spell',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			{
				'petertriho/cmp-git',
				opts = {
					filetypes = {
						'gitcommit',
						'markdown',
					},
				},
			},
		},
		opts = function()
			local cmp = require 'cmp'
			-- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
			return {
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-u>'] = cmp.mapping.scroll_docs(4),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm { select = true },
					--[[ ['<Tab>'] = vim.schedule_wrap(function(fallback)
						if cmp.visible() and has_words_before() then
							cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
						else
							fallback()
						end
					end), ]]
				},
				sources = {
					{ name = 'copilot', group_index = 2 },
					{
						name = 'nvim_lsp',
						entry_filter = function(entry)
							return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
						end,
						group_index = 2,
					},
					{ name = 'git' },
					{ name = 'luasnip' },
					{ name = 'path',    group_index = 2 },
					{ name = 'buffer',  keyword_length = 5, group_index = 2 },
				},
				matching = {
					disallow_fuzzy_matching = true,
					disallow_fullfuzzy_matching = true,
					disallow_partial_fuzzy_matching = true,
					disallow_partial_matching = false,
					disallow_prefix_unmatching = true,
				},
				window = {
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search",
						-- menu position offset
						col_offset = -4,
						-- content offset
						side_padding = 0,
						border = "single",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search",
						border = "single",
					}),
				},
				formatting = {
					fields = { 'kind', 'abbr', 'menu' },
					format = function(entry, vim_item)
						local kind = require('lspkind').cmp_format {
							symbol_map = { Copilot = '', Codeium = '', Snippet = '', Keyword = '' },
							preset = 'codicons',
							maxwidth = 80,
						}(entry, vim_item)
						local strings = vim.split(vim_item.kind, '%s+', { trimempty = true })
						kind.kind = ' ' .. string.format('%s │', strings[1], strings[2]) .. ' '
						return kind
					end,
				},
				sorting = {
					priority_weight = 2,
					comparators = {
						require('copilot_cmp.comparators').prioritize,
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						function(entry1, entry2)
							local _, entry1_under = entry1.completion_item.label:find '^_+'
							local _, entry2_under = entry2.completion_item.label:find '^_+'
							entry1_under = entry1_under or 0
							entry2_under = entry2_under or 0
							if entry1_under > entry2_under then
								return false
							elseif entry1_under < entry2_under then
								return true
							end
						end,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				experimental = {
					ghost_text = {
						hl_group = 'CmpGhostText',
					},
				},
			}
		end,
	},
}
