return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require("nvim-tree").setup({
      -- open_on_setup_file = true
      sort_by = 'extension',
    
      view = {
        width = '20%',
        side = 'left',
        signcolumn = 'no',
      },
    
      renderer = {
        highlight_git = true,
        highlight_opened_files = 'name',
        icons = {
          glyphs = {
            git = {
              unstaged = '!', renamed = '»', untracked = '?', deleted = '✘',
              staged = '✓', unmerged = '', ignored = '◌',
            },
          },
        },
      },
    
      actions = {
        expand_all = {
          max_folder_discovery = 100,
          exclude = { '.git', 'target', 'build' },
        },
      },
    
      on_attach = 'default'
    })
  end,
  keys = {
    { "<C-n>", function()
        local view = require('nvim-tree.view')
        if not view.is_visible() then
          vim.cmd('NvimTreeToggle')
        else
          local cur_win = vim.api.nvim_get_current_win()
          local tree_win = view.get_winnr()
          if cur_win == tree_win then
            vim.cmd('NvimTreeClose')
          else
            vim.api.nvim_set_current_win(tree_win)
          end
        end
      end,
      desc = "Smart toggle NvimTree" }
  },
  init = function()
    vim.cmd("autocmd VimEnter * hi NvimTreeNormal guibg=NONE" )
    vim.cmd("autocmd VimEnter * hi NvimTreeNormalNC guibg=NONE" )
  end,
}
