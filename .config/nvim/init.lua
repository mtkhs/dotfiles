
-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('init.lua', {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', {
    group = augroup,
  }, opts))
end

require('options')
require('keymaps')

require('config.lazy')
require('config.filetype')
require('config.filetype-shebang')
require('config.startup-logo')
require('config.lsp')

