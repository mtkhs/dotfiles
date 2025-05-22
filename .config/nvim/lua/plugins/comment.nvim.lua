return {
  'numToStr/Comment.nvim',
  config = function()
    require("Comment").setup()
  end,
  keys = {
    { "<C-_>", function() require("Comment.api").toggle.linewise.current() end, mode = "n", desc = "Toggle comment" },
    {
      "<C-_>",
      function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "x", false)
        vim.schedule(function()
          local api = require("Comment.api")
          api.locked("toggle.linewise")(vim.fn.visualmode())
        end)
      end,
      mode = "v",
      desc = "Toggle comment (visual)",
    },
    {
      "<C-_>",
      function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
        vim.schedule(function()
          require("Comment.api").toggle.linewise.current()
          vim.api.nvim_feedkeys("a", "n", false) -- insert modeに戻る
        end)
      end,
      mode = "i",
      desc = "Toggle comment (insert)",
    },
  },
}
