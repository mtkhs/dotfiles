return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local langs = { "vim", "vimdoc", "lua", "c", "cpp", "python", "typescript", "javascript", "html", "markdown", "bash" }
    -- require("nvim-treesitter").install(langs)

    local group = vim.api.nvim_create_augroup('MyTreesitterSetup', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = langs,
      callback = function(args)
        -- ハイライトを有効にする
        vim.treesitter.start(args.buf)

        -- インデントを有効にする
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}
