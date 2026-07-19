-- load=function()end: fully deferred. load=false is NOT enough — it behaves like
-- :packadd! and still sources plugin/ files at the end of startup.
vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
}, { load = function() end })

-- approximates lazy.nvim's keys = {...}: load on first keypress
local loaded = false
local function ensure_fzf()
    if loaded then
        return
    end
    loaded = true
    vim.cmd.packadd("fzf-lua") -- add to rtp + source plugin/ (defines :FzfLua)
    require("fzf-lua").setup({})
end

vim.keymap.set("n", "<leader>ff", function() ensure_fzf(); require("fzf-lua").files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() ensure_fzf(); require("fzf-lua").live_grep() end, { desc = "Find Live Grep" })
vim.keymap.set("n", "<leader>fb", function() ensure_fzf(); require("fzf-lua").buffers() end, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fq", function() ensure_fzf(); require("fzf-lua").quickfix() end, { desc = "Find Quickfix" })
vim.keymap.set("n", "<leader>fl", function() ensure_fzf(); require("fzf-lua").loclist() end, { desc = "Find Locationlist" })
vim.keymap.set("n", "<leader>fh", function() ensure_fzf(); require("fzf-lua").help_tags() end, { desc = "Find Help" })
vim.keymap.set("n", "<leader>f=", function() ensure_fzf(); require("fzf-lua").keymaps() end, { desc = "Find Keymaps" })
vim.keymap.set("n", "<leader>fx", function() ensure_fzf(); require("fzf-lua").diagnostics_document() end, { desc = "Find Diagnostic Document" })
vim.keymap.set("n", "<leader>fX", function() ensure_fzf(); require("fzf-lua").diagnostics_workspace() end, { desc = "Find Diagnostic Workspace" })
