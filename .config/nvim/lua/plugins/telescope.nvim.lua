return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true }
  },
  config = function(lazy, opts) 
    local builtin = require('telescope.builtin')
    -- vim.keymap.set('n', '<leader>t', ":Telescope", { noremap = true })
    vim.keymap.set('n', '<C-g>', builtin.current_buffer_fuzzy_find)
    vim.keymap.set('n', '<leader>tf', builtin.find_files)
    vim.keymap.set('n', '<leader>tb', builtin.buffers)
    vim.keymap.set('n', '<leader>tg', builtin.live_grep)
    vim.keymap.set('n', '<leader>tr', '<CMD>Telescope resume<CR>')
    -- vim.keymap.set('n', '<leader>ta', ":Telescope file_browser<CR>")

    local telescope = require('telescope')
    local t_actions = require('telescope.actions')
    local fb_actions = require("telescope").extensions.file_browser.actions
    telescope.setup({
      defaults = {
        wrap_result = true,
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<esc>"] = t_actions.close,
            -- search history
            ["<C-Down>"] = t_actions.cycle_history_next,
            ["<C-Up>"] = t_actions.cycle_history_prev,
          },
        },
        layout_strategy = "vertical",
        layout_config = {
          -- prompt_position = "top",
          -- vertical = {
            -- width = 0.9,
            -- preview_cutoff = 10,
          -- }
        },
        vimgrep_arguments = {
          "rg",
          "--follow",        -- Follow symbolic links
          "--hidden",        -- Search for hidden files
          "--no-heading",    -- Don't group matches by each file
          "--with-filename", -- Print the file path with the matched lines
          "--line-number",   -- Show line numbers
          "--column",        -- Show column numbers
          "--smart-case",    -- Smart case search
          -- Exclude some patterns from search
          "--glob=!**/.git/*",
          "--glob=!**/.idea/*",
          "--glob=!**/.vscode/*",
          "--glob=!**/build/*",
          "--glob=!**/dist/*",
          "--glob=!**/yarn.lock",
          "--glob=!**/package-lock.json",
        },
      },
      pickers = {
        lsp_references = { wrap_results = true, },
        lsp_definitions = { wrap_results = true, },
        diagnostics = { wrap_results = true, },
        find_files = { wrap_results = true, follow = true, hidden = true },
        buffers = { sort_mru = true, ignore_current_buffer = true },
        colorscheme = { enable_preview = true },
      },
      extensions = {
        ["fzf"] = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["file_browser"] = {
          hidden = true,
          follow_symlinks = true,
          hijack_netrw = true,
          git_status = false,
          -- git_status = true,
          mappings = {
            ["i"] = {
              ["~"] = fb_actions.goto_home_dir,
            },
          },
        },
        ["ui-select"] = {
        }
      }
    })
    telescope.load_extension('fzf')
    telescope.load_extension('file_browser')
    telescope.load_extension('ui-select')
  end,
}
