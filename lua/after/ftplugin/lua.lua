if vim.bo.filetype ~= 'lua' then
    return
end

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

vim.opt_local.formatoptions = {
    r = false,      -- do not auto insert commit in next line
    o = false,      -- do not auto commit when use 'o'/'O'
}

vim.opt_local.commentstring = '-- %s'
