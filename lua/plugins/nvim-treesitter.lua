return {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    lazy = false,           -- ensure loaded when startup
    build = ":TSUpdate",    -- auto update parsers
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
    opts = {
        ensure_installed = {
            "lua",
            "c",
            "vim",
            "vimdoc",
            "query",
            "python",
            "markdown",
            "markdown_inline",
        },
    },
}
