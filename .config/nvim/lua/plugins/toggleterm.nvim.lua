return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    -- vim.keymap.set('n', '<C-@>', '<CMD>ToggleTerm<CR>')
    vim.keymap.set('n', '<leader>tt', '<CMD>ToggleTerm<CR>')

    require("toggleterm").setup({
      size = 16,
      open_mapping = [[<C-@>]],
      shading_factor = 2,
      -- direction = "float",
      float_opts = {
        border = "curved",
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }) 
  end,
}
