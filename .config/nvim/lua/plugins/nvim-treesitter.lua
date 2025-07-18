return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function () 
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "vim", "lua", "python", "typescript", "javascript", "html", "markdown", "bash" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
