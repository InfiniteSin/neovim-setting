-- run :TSUpdate after the plugin is installed/updated (like lazy.nvim's build)
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            pcall(vim.cmd, "TSUpdate")
        end
    end,
})

vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}, { load = true })

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
