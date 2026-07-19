-- load=function()end: fully deferred. load=false is NOT enough — it behaves like
-- :packadd! and still sources plugin/ files (which for gitsigns runs a default
-- require('gitsigns').setup()) at the end of startup.
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { load = function() end })

-- approximates lazy.nvim's event = { "BufReadPre", "BufNewFile" }
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function()
        vim.cmd.packadd("gitsigns.nvim") -- add to rtp + source plugin/ (defines :Gitsigns)
        require("gitsigns").setup({
            signs = {
                add = { text = "\u{2590}" }, -- ▏
                change = { text = "\u{2590}" }, -- ▐
                delete = { text = "\u{2590}" }, -- ◦
                topdelete = { text = "\u{25e6}" }, -- ◦
                changedelete = { text = "\u{25cf}" }, -- ●
                untracked = { text = "\u{25cb}" }, -- ○
            },
            signcolumn = true,
            current_line_blame = false,
        })
    end,
})
