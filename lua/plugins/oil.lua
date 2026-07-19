-- disable netrw; oil.nvim is the file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- load=function()end: fully deferred. load=false is NOT enough — it behaves like
-- :packadd! and still sources plugin/ files at the end of startup.
vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
}, { load = function() end })

local oil_opts = {
    columns = {
        "permissions",
        "icon",
        "size",
        "mtime",
    },
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
        -- show hidden files
        show_hidden = true,
    },
}

local loaded = false
local function ensure_oil()
    if loaded then
        return
    end
    loaded = true
    vim.cmd.packadd("oil.nvim") -- add to rtp (oil has no plugin/ files)
    require("oil").setup(oil_opts) -- defines the real :Oil, replacing the stub below
end

-- approximates lazy.nvim's cmd = { "Oil" }: load on first :Oil
vim.api.nvim_create_user_command("Oil", function(cmd_opts)
    ensure_oil()
    if cmd_opts.args ~= "" then
        vim.cmd("Oil " .. cmd_opts.args)
    else
        vim.cmd.Oil()
    end
end, { nargs = "*", desc = "Open oil.nvim (lazy loads it first)" })

-- approximates lazy.nvim's keys = { "-" }
vim.keymap.set("n", "-", function()
    ensure_oil()
    require("oil").open()
end, { desc = "Toggle Oil" })

-- load oil when a directory buffer is opened (netrw hijack replacement)
vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
    callback = function(ev)
        if loaded then
            return true -- oil's own autocmds take over from here
        end
        local dir = vim.api.nvim_buf_get_name(ev.buf)
        if vim.fn.isdirectory(dir) ~= 1 then
            return
        end
        ensure_oil()
        require("oil").open(dir)
        return true -- delete this autocmd
    end,
})
