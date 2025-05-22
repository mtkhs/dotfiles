return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'onsails/lspkind-nvim',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = {
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "cmdline" },
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<ESC>'] = cmp.mapping.abort(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-l>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm { select = true },
      }),
      experimental = {
        ghost_text = true,
      },
      formatting = {
        format = require('lspkind').cmp_format {
          mode = 'symbol',
          preset = 'codicons',
          menu = {
            luasnip = "[luasnip]",
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            path = "[Path]",
            cmdline = "[Cmdline]",
	  },
        },
      }, 
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources {
        { name = 'cmdline' },
        { name = 'path' },
      },
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources {
        {
          name = 'buffer',
          option = {
            keyword_pattern = [[\k\+]],
          },
        },
      },
    })
  end
}
