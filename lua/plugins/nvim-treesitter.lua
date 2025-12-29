require("nvim-treesitter").setup({
    ensure_installed = {
        "c",
        "lua",
        "python",
        "vim",
        "vimdoc",
    },
    auto_install = false,
    highlight = {
        enable = true,
        additonal_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
})
