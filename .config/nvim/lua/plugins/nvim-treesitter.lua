return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "python", "typescript", "javascript", "html", "markdown", "bash" },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
