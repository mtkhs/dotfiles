return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
  },
  config = function()
    require("nvim-tree").setup({
      open_on_setup_file = true
    })
  end,
}
