return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {},
    init = function()
        local treesitter = require('nvim-treesitter')
        treesitter.setup({
            highlight = { enable = true },
            -- indent = { enable = true },
            fold = {
                enable = true,
                foldopen = 'foldopen',
            },

        })
        local ensure_installed = {
            "vim",
            "vimdoc",
            "rust",
            "c",
            "cpp",
            "go",
            "html",
            "css",
            "javascript",
            "json",
            "lua",
            "markdown",
            "python",
            "typescript",
            "vue",
            "svelte",
            "bash",
            "lua",
            "python",
        }

        local config = require("nvim-treesitter.config")

        local already_installed = config.get_installed()
        local parsers_to_install = {}

        for _, parser in ipairs(ensure_installed) do
            if not vim.tbl_contains(already_installed, parser) then
                table.insert(parsers_to_install, parser)
            end
        end

        if #parsers_to_install > 0 then
            treesitter.install(parsers_to_install)
        end

        vim.opt.foldmethod = "manual"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    end,
}
