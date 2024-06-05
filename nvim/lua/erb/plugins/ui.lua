return {
	{
		'folke/noice.nvim',
		-- enabled = false,
		opts = {
			cmdline = {
				view = 'cmdline',
				format = {
					cmdline = { icon = ">" },
					search_down = { icon = "🔍⌄" },
					search_up = { icon = "🔍⌃" },
					filter = { icon = "$" },
					lua = { icon = "☾" },
					help = { icon = "?" },
				},
			},
			messages = {
				enabled = true,
			},
			routes = {
				{
					filter = {
						event = "notify",
						find = "nohlsearch",
					},
					opts = { skip = true },
				},
			},
			commands = {
				history = {
					view = 'popup',
					opts = { enter = true, format = 'details' },
					filter = {
						any = {
							{ event = 'notify' },
							{ error = true },
							{ warning = true },
							{ event = 'msg_show', kind = { '' } },
							{ event = 'lsp',      kind = 'message' },
						},
					},
				},
			},
			format = {
				level = {
					icons = {
						error = "✖",
						warn = "▼",
						info = "●",
					},
				},
			},
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
				documentation = {
					view = 'hover',
					opts = {
						lang = 'markdown',
						replace = true,
						render = 'plain',
						format = { '{message}' },
						win_options = { concealcursor = 'n', conceallevel = 3 },
					},
				},
			},
			presets = {
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
			views = {
				mini = {
					position = {
						row = '90%',
						col = '100%',
					},
				},
				cmdline_popup = {
					border = {
						style = 'none',
						padding = { 2, 3 },
					},
					filter_options = {},
					win_options = {
						winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
					},
				},
			},
		},
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
		},
	}
}
