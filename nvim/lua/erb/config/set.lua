vim.opt.guicursor = ''

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars = { space = '⋅', trail = '⋅', tab = '  ' }

vim.o.updatetime = 500
vim.o.timeout = true
vim.opt.colorcolumn = { 80 }


--[[ vim.opt.listchars = {
	tab = ' .',
	extends = '⟫',
	precedes = '⟪',
	nbsp = '␣',
	trail = '·'
} ]]
--[[ vim.opt.fillchars = {
	foldopen = '󰅀', -- 󰅀 
	foldclose = '󰅂', -- 󰅂 
	fold = ' ',
	foldsep = ' ',
	diff = '╱',
	eob = ' ',
	horiz = '━',
	horizup = '┻',
	horizdown = '┳',
	vert = '┃',
	vertleft = '┫',
	vertright = '┣',
	verthoriz = '╋',
} ]]

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = '0'
vim.opt.foldenable = true
