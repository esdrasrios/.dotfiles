local function get_path_from_home()
	local cwd = vim.fn.getcwd()
	if cwd == os.getenv 'HOME' then
		return '~'
	else
		return vim.fn.fnamemodify(cwd, ':t')
	end
end

local theme = {
	aqua = '#7AB0DF',
	bg = '#141414',
	blue = '#5FB0FC',
	cyan = '#70C0BA',
	darkred = '#FB7373',
	fg = '#C7C7CA',
	gray = '#222730',
	green = '#afcb85',
	lime = '#54CED6',
	orange = '#FFD064',
	pink = '#D997C8',
	purple = '#C397D8',
	red = '#ef616c',
	yellow = '#FFE59E',
}

vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#101317', fg = '#101317' })

local mode_theme = {
	['NORMAL'] = theme.green,
	['OP'] = theme.darkred,
	['INSERT'] = theme.red,
	['VISUAL'] = theme.yellow,
	['LINES'] = theme.orange,
	['BLOCK'] = theme.orange,
	['REPLACE'] = theme.darkred,
	['V-REPLACE'] = theme.pink,
	['ENTER'] = theme.pink,
	['MORE'] = theme.pink,
	['SELECT'] = theme.darkred,
	['SHELL'] = theme.cyan,
	['TERM'] = theme.lime,
	['NONE'] = theme.gray,
	['COMMAND'] = theme.blue,
}

local vi_mode_text = {
	n = 'NORMAL',
	i = 'INSERT',
	v = 'VISUAL',
	[''] = 'V-BLOCK',
	V = 'V-LINE',
	c = 'COMMAND',
	no = 'UNKNOWN',
	s = 'UNKNOWN',
	S = 'UNKNOWN',
	ic = 'UNKNOWN',
	R = 'REPLACE',
	Rv = 'UNKNOWN',
	cv = 'UNKWON',
	ce = 'UNKNOWN',
	r = 'REPLACE',
	rm = 'UNKNOWN',
	t = 'INSERT',
}

local modes = setmetatable({
	['n'] = 'N',
	['no'] = 'N',
	['v'] = 'V',
	['V'] = 'VL',
	[''] = 'VB',
	['s'] = 'S',
	['S'] = 'SL',
	[''] = 'SB',
	['i'] = 'I',
	['ic'] = 'I',
	['R'] = 'R',
	['Rv'] = 'VR',
	['c'] = 'C',
	['cv'] = 'EX',
	['ce'] = 'X',
	['r'] = 'P',
	['rm'] = 'M',
	['r?'] = 'C',
	['!'] = 'SH',
	['t'] = 'T',
}, {
	__index = function()
		return '-'
	end,
})


local c = {
	vim_mode_border = {
		provider = ' ',
		hl = function()
			return {
				fg = 'bg',
				bg = require('feline.providers.vi_mode').get_mode_color(),
				style = 'bold',
				name = 'NeovimModeHLColor',
			}
		end,
	},
	harpoon = {
		provider = require('harpoon.mark').status(),
		hl = function()
			return {
				fg = 'bg',
				bg = 'blue',
				style = 'bold',
			}
		end,
		left_sep = {
			str = ' ',
			hl = {
				bg = 'blue',
			},
		},
		right_sep = {
			str = ' ',
			hl = {
				bg = 'blue',
			},
		},
	},
	vim_mode = {
		provider = function()
			local current_text = ' ' .. vi_mode_text[vim.fn.mode()] .. ' '
			return current_text
		end,
		--[[ provider = function()
			return modes[vim.api.nvim_get_mode().mode]
		end, ]]
		hl = function()
			return {
				fg = 'bg',
				bg = require('feline.providers.vi_mode').get_mode_color(),
				style = 'bold',
				name = 'NeovimModeHLColor',
			}
		end,
		left_sep = 'block',
		right_sep = 'block',
	},
	cwd = {
		provider = get_path_from_home,
		hl = {
			fg = 'fg',
			bg = 'bg',
			style = 'bold',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	gitBranch = {
		provider = 'git_branch',
		left_sep = 'block',
		right_sep = 'block',
	},
	gitDiffAdded = {
		provider = 'git_diff_added',
		hl = {
			fg = 'green',
			bg = 'bg',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	gitDiffRemoved = {
		provider = 'git_diff_removed',
		hl = {
			fg = 'red',
			bg = 'bg',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	gitDiffChanged = {
		provider = 'git_diff_changed',
		hl = {
			fg = 'fg',
			bg = 'bg',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	separator = {
		provider = '',
	},
	fileinfo = {
		provider = {
			name = 'file_info',
			opts = {
				type = 'base-only',
				file_readonly_icon = '',
				file_modified_icon = '',
			},
		},
		hl = {
			style = 'bold',
		},
		icon = '',
		left_sep = ' ',
		right_sep = ' ',
	},
	diagnostic_errors = {
		provider = 'diagnostic_errors',
		hl = {
			fg = 'red',
		},
	},
	diagnostic_warnings = {
		provider = 'diagnostic_warnings',
		hl = {
			fg = 'yellow',
		},
	},
	diagnostic_hints = {
		provider = 'diagnostic_hints',
		hl = {
			fg = 'aqua',
		},
	},
	diagnostic_info = {
		provider = 'diagnostic_info',
	},
	lsp_client_names = {
		provider = function()
			return 'ALL HUMANS DIE THE SAME לּ 言語サー'
		end,
		hl = function()
			return {
				fg = 'yellow',
				bg = 'bg',
				style = 'bold',
			}
		end,
		left_sep = '',
		right_sep = 'block',
	},
	file_type = {
		provider = {
			name = 'file_type',
			opts = {
				filetype_icon = true,
			},
		},
		hl = {
			fg = 'fg',
			bg = 'bg',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	file_encoding = {
		provider = 'file_encoding',
		hl = {
			fg = 'orange',
			bg = 'bg',
			style = 'italic',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	position = {
		provider = 'position',
		hl = {
			fg = 'green',
			bg = 'bg',
			style = 'bold',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	line_percentage = {
		provider = 'line_percentage',
		hl = {
			fg = 'aqua',
			bg = 'bg',
			style = 'bold',
		},
		left_sep = 'block',
		right_sep = 'block',
	},
	scroll_bar = {
		provider = function()
			local chars = setmetatable({
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
				' ',
			}, {
				__index = function()
					return ' '
				end,
			})
			local line_ratio = vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0)
			local position = math.floor(line_ratio * 100)

			local icon = chars[math.floor(line_ratio * #chars)] .. position
			if position <= 5 then
				icon = ' TOP'
			elseif position >= 95 then
				icon = ' BOT'
			end
			return icon
		end,
		hl = function()
			local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
			local fg
			local style

			if position <= 5 then
				fg = 'aqua'
				style = 'bold'
			elseif position >= 95 then
				fg = 'red'
				style = 'bold'
			else
				fg = 'purple'
				style = nil
			end
			return {
				fg = fg,
				style = style,
				bg = 'bg',
			}
		end,
		left_sep = 'block',
		right_sep = 'block',
	},
}

local left = {
	c.vim_mode,
	c.cwd,
	c.gitBranch,
	c.gitDiffAdded,
	c.gitDiffRemoved,
	c.gitDiffChanged,
	c.diagnostic_errors,
	c.diagnostic_warnings,
	c.diagnostic_info,
	c.diagnostic_hints,
	c.separator,
}

local middle = {
	c.fileinfo,
}

local right = {
	-- c.lsp_client_names,
	c.file_type,
	c.position,
	c.scroll_bar,
	c.vim_mode_border,
}

local components = {
	active = {
		left,
		middle,
		right,
	},
	inactive = {
		middle,
		left,
		right,
	},
}

return {
	{ 'nvim-tree/nvim-web-devicons' },
	{
		'freddiehaddad/feline.nvim',
		opts = {
			components = components,
			theme = theme,
			vi_mode_colors = mode_theme,
			force_inactive = {
				filetypes = {
					'^qf$',
					'^help$',
					'Outline',
					'Trouble',
					'dap-repl',
					'^dapui',
				},
				buftypes = {},
				bufnames = {},
			},
			disable = {
				filetypes = {
					'NvimTree',
				},
				buftypes = {},
				bufnames = {},
			},
		},
	},
}
