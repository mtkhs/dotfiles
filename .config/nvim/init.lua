-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('init.lua', {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', {
    group = augroup,
  }, opts))
end

require('config.filetype')
require('config.filetype-shebang')
require('config.lazy')
require('config.startup-logo')
require('options')
require('keymaps')

-- vim.cmd([[colorscheme tokyonight]])

