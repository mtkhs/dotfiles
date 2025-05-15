
--
-- encoding
--
vim.opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'

vim.opt.termguicolors = true

vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度

vim.opt.clipboard:append('unnamedplus,unnamed')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- vim.opt.ambiwidth = 'double'
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~'

--
-- wrap lines
--
vim.opt.wrap = true
vim.opt.showbreak = '↪'

