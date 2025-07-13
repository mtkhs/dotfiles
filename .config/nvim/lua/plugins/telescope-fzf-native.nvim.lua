return {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    -- event = { "VeryLazy" },
    config = function()
        require("telescope").load_extension("fzf")
    end,
}
