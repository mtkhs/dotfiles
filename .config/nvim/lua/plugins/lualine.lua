return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-web-devicons', opt = true },
  event = {'BufNewFile', 'BufRead'},
  config = function()
    require('lualine').setup()
  end,
}
