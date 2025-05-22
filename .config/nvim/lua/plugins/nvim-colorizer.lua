return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require("colorizer").setup({
      "*",
      css = { rgb_fn = true },
      html = { rgb_fn = true },
    }, {
      RRGGBBAA = true,
    })
  end,
}
