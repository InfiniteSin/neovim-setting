require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua",
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
