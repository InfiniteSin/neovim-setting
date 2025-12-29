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

vim.api.nvim_create_user_command('TSListIn', function()
    require('nvim-treesitter.config').get_installed()
end, {
    bang = true,
    desc = 'List installed treesitter parsers',
})

vim.api.nvim_create_user_command('TSListAvaliable', function()
    require('nvim-treesitter.config').get_available()
end, {
    bang = true,
    desc = 'List avaliable treesitter parsers',
})
