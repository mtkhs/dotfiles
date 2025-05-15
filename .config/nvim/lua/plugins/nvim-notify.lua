return {
  'rcarriga/nvim-notify',
  config = function()
    notify = require('notify')
    notify.setup()
    vim.notify = notify
  end,
}
