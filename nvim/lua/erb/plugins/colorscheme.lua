local function tokyonight_cfg()
	require('tokyonight').setup {
		style = 'night',
		light_style = 'day',
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in
		on_highlights = function(hl, c)
			local prompt = '#2d3149'
			hl.LineNr = {
				bg = c.bg_dark,
				fg = c.fg_dark,
			}
			hl.CursorLine = {
				bg = c.bg_dark,
			}
			hl.TelescopeNormal = {
				bg = c.bg_dark,
				fg = c.fg_dark,
			}
			hl.TelescopeBorder = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
			hl.TelescopePromptNormal = {
				bg = prompt,
			}
			hl.TelescopePromptBorder = {
				bg = prompt,
				fg = prompt,
			}
			hl.TelescopePromptTitle = {
				bg = prompt,
				fg = prompt,
			}
			hl.TelescopePreviewTitle = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
			hl.TelescopeResultsTitle = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
		end,
	}
end

local function fluoromachine_cfg()
	local fm = require 'fluoromachine'
	function overrides(c)
		return {
			['Comment'] = { italic = false, bold = false },
			['Type'] = { italic = false, bold = false },
			['@type'] = { italic = false, bold = false },
			['@type.builtin'] = { italic = false, bold = false },
			['@attribute'] = { italic = false, bold = false },
			['@function'] = { italic = false, bold = false },
			['@function.call'] = { italic = false, bold = true },
			['@comment'] = { italic = false },
			['@keyword'] = { italic = false },
			['@keyword.return'] = { italic = false, bold = true },
			['@keyword.coroutine'] = { italic = false, bold = true },
			['@constant'] = { italic = false, bold = false },
			['@exception'] = { italic = false, bold = true },
			['@method'] = { italic = false, bold = true },
			['@method.call'] = { italic = false, bold = true },
			['@variable'] = { italic = false },
			['@variable.builtin'] = { italic = false },
			['@field'] = { italic = false },
			['@parameter'] = { italic = false },
			TelescopeBorder = { fg = c.telescope.bg_alt, bg = c.telescope.bg },
			TelescopeNormal = { bg = c.telescope.bg },
			TelescopePreviewBorder = { fg = c.telescope.bg, bg = c.telescope.bg },
			TelescopePreviewTitle = { fg = c.telescope.bg, bg = c.telescope.green },
			TelescopePromptBorder = { fg = c.telescope.bg_alt, bg = c.telescope.bg_alt },
			TelescopePromptNormal = { fg = c.telescope.fg, bg = c.telescope.bg_alt },
			TelescopePromptPrefix = { fg = c.telescope.red, bg = c.telescope.bg_alt },
			TelescopePromptTitle = { fg = c.telescope.bg_alt, bg = c.telescope.red },
			TelescopeResultsBorder = { fg = c.telescope.bg, bg = c.telescope.bg },
			TelescopeResultsTitle = { fg = c.telescope.bg, bg = c.telescope.bg },
		}
	end

	--[[ fm.setup {
		theme = 'delta',
		colors = function(_, d)
			return {
				telescope = {
					bg_alt = _.alt_bg,
					bg = _.bg,
					fg = _.fg,
					green = _.green,
					red = _.red,
				},
			}
		end,
		overrides = overrides,
	} ]]
end

local function nightfox_cfg()
	require('nightfox').setup {
		--[[ options = {
			compile_path = vim.fn.stdpath 'cache' .. '/nightfox',
			compile_file_suffix = '_compiled',
			transparent = false,
			terminal_colors = false,
			dim_inactive = false,
			module_default = false,
			styles = {
				comments = 'NONE',
				conditionals = 'NONE',
				constants = 'NONE',
				functions = 'NONE',
				keywords = 'NONE',
				numbers = 'NONE',
				operators = 'NONE',
				strings = 'NONE',
				types = 'NONE',
				variables = 'NONE',
			},
			inverse = {
				match_paren = false,
				visual = false,
				search = false,
			},
			modules = {},
		}, ]]
		--[[ palettes = {
			carbonfox = {
				yellow = '#ffcc00',
				pink = '#fc199a',
				cyan = '#61e2ff',
				green = '#a3be8c',
				red = '#c94f6d',
			},
		}, ]]
		specs = {
			all = {
				telescope = {
					bg_alt = 'bg2',
					bg = 'bg1',
					fg = 'fg1',
					green = 'green',
					red = 'red',
				},
			},
			carbonfox = {
				syntax = {
					yellow = 'yellow',
					cyan = 'cyan',
					red = 'red',
					keyword = 'pink',
					type = 'magenta',
					field = 'magenta',
					func = 'yellow',
					const = 'red',
					operator = 'pink',
				},
			},
		},
		groups = {
			all = {
				TelescopeBorder = { fg = 'telescope.bg_alt', bg = 'telescope.bg' },
				TelescopeNormal = { bg = 'telescope.bg' },
				TelescopePreviewBorder = { fg = 'telescope.bg', bg = 'telescope.bg' },
				TelescopePreviewTitle = { fg = 'telescope.bg', bg = 'telescope.green' },
				TelescopePromptBorder = { fg = 'telescope.bg_alt', bg = 'telescope.bg_alt' },
				TelescopePromptNormal = { fg = 'telescope.fg', bg = 'telescope.bg_alt' },
				TelescopePromptPrefix = { fg = 'telescope.red', bg = 'telescope.bg_alt' },
				TelescopePromptTitle = { fg = 'telescope.bg', bg = 'telescope.red' },
				TelescopeResultsBorder = { fg = 'telescope.bg', bg = 'telescope.bg' },
				TelescopeResultsTitle = { fg = 'telescope.bg', bg = 'telescope.bg' },
				IndentBlanklineSpaceChar = { fg = 'telescope.bg_alt' },
				NormalFloat = { bg = 'telescope.bg' },
				FloatBorder = { bg = 'telescope.bg' },
			},
			carbonfox = {
				['@method.call'] = { fg = 'syntax.yellow' },
				['@parameter'] = { fg = 'syntax.cyan' },
				['@boolean'] = { fg = 'syntax.red' },
			},
		},
	}
end

local function rose_pine_cfg()
	require('rose-pine').setup {
		bold_vert_split = false,
		dim_nc_background = true,
		disable_italics = true,
		styles = {
			italic = false,
		},
		highlight_groups = {
			StatusLine = { fg = 'love', bg = 'love', blend = 10 },
			StatusLineNC = { fg = 'subtle', bg = 'surface' },
			Search = { bg = 'gold', inherit = false },
			TelescopeBorder = { fg = 'overlay', bg = 'overlay' },
			TelescopeNormal = { fg = 'subtle', bg = 'overlay' },
			TelescopeSelection = { fg = 'text', bg = 'highlight_med' },
			TelescopeSelectionCaret = { fg = 'love', bg = 'highlight_med' },
			TelescopeMultiSelection = { fg = 'text', bg = 'highlight_high' },

			TelescopeTitle = { fg = 'base', bg = 'love' },
			TelescopePromptTitle = { fg = 'base', bg = 'pine' },
			TelescopePreviewTitle = { fg = 'base', bg = 'iris' },

			TelescopePromptNormal = { fg = 'text', bg = 'surface' },
			TelescopePromptBorder = { fg = 'surface', bg = 'surface' },
			-- GitSignsAdd = { bg = 'nop' },
			-- GitSignsChange = { bg = 'nop' },
			-- GitSignsDelete = { bg = 'nop' },
			-- SignAdd = { link = 'GitSignsAdd' },
			-- SignChange = { link = 'GitSignsChange' },
			-- SignDelete = { link = 'GitSignsDelete' },
		},
	}
end

return {
	{ 'rebelot/kanagawa.nvim' },
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
		opts = {
			integrations = {
				telescope = {
					enabled = true,
					style = 'nvchad',
				},
				which_key = true,
			},
		},
	},
	{ 'tiagovla/tokyodark.nvim' },
	{ 'embark-theme/vim' },
	{ 'iagorrr/noctishc.nvim' },
	{ 'jaredgorski/spacecamp' },
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			tokyonight_cfg()
		end,
	},
	{
		'maxmx03/fluoromachine.nvim',
		config = function()
			fluoromachine_cfg()
		end,
	},
	{
		'EdenEast/nightfox.nvim',
		config = function()
			nightfox_cfg()
		end,
		init = function()
			vim.cmd 'colorscheme nightfox'
		end,
	},
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		--[[ init = function()
			vim.cmd 'colorscheme rose-pine'
		end, ]]
		--[[ config = function()
			rose_pine_cfg()
		end, ]]
	},
	--[[ {
		'barrientosvctor/abyss.nvim',
		lazy = false,
		priority = 1000,
		-- opts = {}
	}, ]]
	--[[ {
		'olivercederborg/poimandres.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('poimandres').setup {}
		end,
		init = function()
			vim.cmd("colorscheme poimandres")
		end
	}, ]]
	--[[ {
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				-- Recommended - see "Configuring" below for more config options
				transparent = true,
				italic_comments = true,
				hide_fillchars = true,
				borderless_telescope = true,
			})
			vim.cmd("colorscheme cyberdream") -- set the colorscheme
		end,
	}, ]]
	--[[ {
		"nyoom-engineering/oxocarbon.nvim"
		-- Add in any other configuration;
		--   event = foo,
		--   config = bar
		--   end,
	}, ]]
	--[[ {
		'disrupted/one.nvim', -- personal tweaked colorscheme
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.o.background = 'light'
			require('one').colorscheme()
		end,
	}, ]]
	{
		'esdrasrios/fleet-theme-nvim',
		dir = '/Users/esdrasriosbaia/code/rlshit/fleet-theme-nvim/',
		config = function()
			vim.cmd 'colorscheme fleet'
		end,
	},
}
