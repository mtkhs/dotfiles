return {
    "williamboman/mason.nvim",
    enabled = false,
    requires = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
    end,
}
