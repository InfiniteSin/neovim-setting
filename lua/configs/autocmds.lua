-- Enable Treesitter highlight for installed languages
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua' },
    callback = function()
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
        -- folds, provided by Neovim
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'
        -- indentation, provided by Neovim
        -- vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end,
})

