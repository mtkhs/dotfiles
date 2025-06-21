return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({
      options = {
        offsets = {
            { filetype = "NvimTree", text = "", padding = 1 },
        },
        -- always_show_bufferline = false,
        show_buffer_close_icons = false,
        sort_by = "insert_after_current",
        max_prefix_length = 8,
      },
    })
  end,
}
