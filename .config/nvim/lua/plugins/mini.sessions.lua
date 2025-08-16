return {
  'echasnovski/mini.sessions',
  config = function()
    require('mini.sessions').setup({
      autoread = false,
      autowrite = false,
    })

    vim.api.nvim_create_user_command('SessionWrite', function(arg)
      MiniSessions.write(arg.args)
    end, { desc = 'Write session', nargs = '?' })
    vim.api.nvim_create_user_command('SessionDelete', function()
      MiniSessions.select('delete')
    end, { desc = 'Delete session' })
    vim.api.nvim_create_user_command('SessionLoad', function()
      MiniSessions.select('read')
    end, { desc = 'Load session' })
    vim.api.nvim_create_user_command('SessionEscape', function()
      vim.v.this_session = ''
    end, { desc = 'Load session' })
  end
}
