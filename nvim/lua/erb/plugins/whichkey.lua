return {
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		iopts = function()
			---@type table<string, string|table>
			local i = {
				[' '] = 'Whitespace',
				['"'] = 'Balanced "',
				["'"] = "Balanced '",
				['`'] = 'Balanced `',
				['('] = 'Balanced (',
				[')'] = 'Balanced ) including white-space',
				['>'] = 'Balanced > including white-space',
				['<lt>'] = 'Balanced <',
				[']'] = 'Balanced ] including white-space',
				['['] = 'Balanced [',
				['}'] = 'Balanced } including white-space',
				['{'] = 'Balanced {',
				['?'] = 'User Prompt',
				_ = 'Underscore',
				a = 'Argument',
				b = 'Balanced ), ], }',
				c = 'Class',
				f = 'Function',
				o = 'Block, conditional, loop',
				q = 'Quote `, ", \'',
				t = 'Tag',
			}
			local a = vim.deepcopy(i)
			for k, v in pairs(a) do
				a[k] = v:gsub(' including.*', '')
			end

			local ic = vim.deepcopy(i)
			local ac = vim.deepcopy(a)
			for key, name in pairs { n = 'Next', l = 'Last' } do
				i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
				a[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, ac)
			end
			return {
				defaults = {
					mode = { 'n', 'v' },
					['g'] = { name = '+goto' },
					['gs'] = { name = '+surround' },
					[']'] = { name = '+next' },
					['['] = { name = '+prev' },
					['<leader><tab>'] = { name = '+tabs' },
					['<leader>b'] = { name = '+buffer' },
					['<leader>c'] = { name = '+code' },
					['<leader>f'] = { name = '+file/find' },
					['<leader>g'] = { name = '+git' },
					['<leader>gh'] = { name = '+hunks' },
					['<leader>q'] = { name = '+quit/session' },
					['<leader>s'] = { name = '+search' },
					['<leader>u'] = { name = '+ui' },
					['<leader>w'] = { name = '+windows' },
					['<leader>x'] = { name = '+diagnostics/quickfix' },
				},
			}
		end,
		opts = {
			plugins = {
				spelling = {
					enabled = true,
					suggestions = 20,
				},
			},
		},
		config = function()
			local register = require('which-key').register
			register({
				b = { name = "Buffers" },
				c = { name = "Code" },
				f = { name = "Find" },
				g = { name = "Git" },
				l = { name = "Lazy" },
				r = { name = "Run Code" },
				s = { name = "Session" },
				u = { name = "UI" },
				t = { name = "Terminal" },
				n = { name = "Noice" },
				x = { name = "trouble" },
				h = { name = "profile" },
			}, { prefix = "<leader>", mode = "n" })


			register({
				c = {
					name = "Comment",
					c = "Toggle line comment",
					b = "Toggle block comment",
					a = "Insert line comment to line end",
					j = "Insert line comment to next line",
					k = "Insert line comment to previous line",
				},
			}, { prefix = "g", mode = "n" })

			register({
				c = "Switch the specified line to a line comment",
				b = "Switch the specified line to a block comment",
			}, { prefix = "g", mode = "v" })
		end,
	},
}
