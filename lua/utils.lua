local user_config_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

local function pack_clean()
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end
    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        print("No unused plugins")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

vim.api.nvim_create_user_command('PackClean', function(opts)
    pack_clean()
end, { 
desc = 'Clean unused plugins',
force = false,
})


-- Clear all local files of plugin installed by vim.pack
local function plugin_clear()
    local path = vim.fn.stdpath('data') .. "/site/pack/core/opt"
    vim.fn.delete(path, 'rf')
end

vim.api.nvim_create_user_command('PluginClear', function(opts)
    plugin_clear()
    local choice = vim.fn.confirm('Restart?: ', '&Yes\n&No', 2)
    if choice == 1 then
        vim.cmd('restart')
    end
end, { 
desc = 'Clean all files of plugin installed by vim.pack',
force = false,
})


-- User Defined Dynamic Statusline
-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
    local now = vim.loop.now()
    if now - last_check > 5000 then -- Check every 5 seconds
        cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
        last_check = now
    end
    if cached_branch ~= "" then
        return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
    end
    return ""
end

-- File type with Nerd Font icon
local function file_type()
    local ft = vim.bo.filetype
    local icons = {
        lua = "\u{e620} ", -- nf-dev-lua
        python = "\u{e73c} ", -- nf-dev-python
        javascript = "\u{e74e} ", -- nf-dev-javascript
        typescript = "\u{e628} ", -- nf-dev-typescript
        javascriptreact = "\u{e7ba} ",
        typescriptreact = "\u{e7ba} ",
        html = "\u{e736} ", -- nf-dev-html5
        css = "\u{e749} ", -- nf-dev-css3
        scss = "\u{e749} ",
        json = "\u{e60b} ", -- nf-dev-json
        markdown = "\u{e73e} ", -- nf-dev-markdown
        vim = "\u{e62b} ", -- nf-dev-vim
        sh = "\u{f489} ", -- nf-oct-terminal
        bash = "\u{f489} ",
        zsh = "\u{f489} ",
        rust = "\u{e7a8} ", -- nf-dev-rust
        go = "\u{e724} ", -- nf-dev-go
        c = "\u{e61e} ", -- nf-dev-c
        cpp = "\u{e61d} ", -- nf-dev-cplusplus
        java = "\u{e738} ", -- nf-dev-java
        php = "\u{e73d} ", -- nf-dev-php
        ruby = "\u{e739} ", -- nf-dev-ruby
        swift = "\u{e755} ", -- nf-dev-swift
        kotlin = "\u{e634} ",
        dart = "\u{e798} ",
        elixir = "\u{e62d} ",
        haskell = "\u{e777} ",
        sql = "\u{e706} ",
        yaml = "\u{f481} ",
        toml = "\u{e615} ",
        xml = "\u{f05c} ",
        dockerfile = "\u{f308} ", -- nf-linux-docker
        gitcommit = "\u{f418} ", -- nf-oct-git_commit
        gitconfig = "\u{f1d3} ", -- nf-fa-git
        vue = "\u{fd42} ", -- nf-md-vuejs
        svelte = "\u{e697} ",
        astro = "\u{e628} ",
    }

    if ft == "" then
        return " \u{f15b} " -- nf-fa-file_o
    end

    return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size with Nerd Font icon
local function file_size()
    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size < 0 then
        return ""
    end
    local size_str
    if size < 1024 then
        size_str = size .. "B"
    elseif size < 1024 * 1024 then
        size_str = string.format("%.1fK", size / 1024)
    else
        size_str = string.format("%.1fM", size / 1024 / 1024)
    end
    return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
        n = " \u{f121}  NORMAL",
        i = " \u{f11c}  INSERT",
        v = " \u{f0168} VISUAL",
        V = " \u{f0168} V-LINE",
        ["\22"] = " \u{f0168} V-BLOCK",
        c = " \u{f120} COMMAND",
        s = " \u{f0c5} SELECT",
        S = " \u{f0c5} S-LINE",
        ["\19"] = " \u{f0c5} S-BLOCK",
        R = " \u{f044} REPLACE",
        r = " \u{f044} REPLACE",
        ["!"] = " \u{f489} SHELL",
        t = " \u{f120} TERMINAL",
    }
    return modes[mode] or (" \u{f059} " .. mode)
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        callback = function()
            vim.opt_local.statusline = table.concat({
                "  ",
                "%#StatusLineBold#",
                "%{v:lua.mode_icon()}",
                "%#StatusLine#",
                " \u{e0b1} %f %h%m%r", -- nf-pl-left_hard_divider
                "%{v:lua.git_branch()}",
                "\u{e0b1} ", -- nf-pl-left_hard_divider
                "%{v:lua.file_type()}",
                "\u{e0b1} ", -- nf-pl-left_hard_divider
                "%{v:lua.file_size()}",
                "%=", -- Right-align everything after this
                " \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
            })
        end,
    })
    vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        callback = function()
            vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
        end,
    })
end

setup_dynamic_statusline()

local function lsp_on_attach(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
        return
    end

    local bufnr = ev.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- vim.keymap.set("n", "<leader>gd", function()
    --     require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
    -- end, opts)
    --
    -- vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)
    --
    -- vim.keymap.set("n", "<leader>gS", function()
    --     vim.cmd("vsplit")
    --     vim.lsp.buf.definition()
    -- end, opts)
    --
    -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    --
    -- vim.keymap.set("n", "<leader>D", function()
    --     vim.diagnostic.open_float({ scope = "line" })
    -- end, opts)
    -- vim.keymap.set("n", "<leader>d", function()
    --     vim.diagnostic.open_float({ scope = "cursor" })
    -- end, opts)
    -- vim.keymap.set("n", "<leader>nd", function()
    --     vim.diagnostic.jump({ count = 1 })
    -- end, opts)
    --
    -- vim.keymap.set("n", "<leader>pd", function()
    --     vim.diagnostic.jump({ count = -1 })
    -- end, opts)
    --
    -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    --
    -- vim.keymap.set("n", "<leader>fd", function()
    --     require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
    -- end, opts)
    -- vim.keymap.set("n", "<leader>fr", function()
    --     require("fzf-lua").lsp_references()
    -- end, opts)
    -- vim.keymap.set("n", "<leader>ft", function()
    --     require("fzf-lua").lsp_typedefs()
    -- end, opts)
    -- vim.keymap.set("n", "<leader>fs", function()
    --     require("fzf-lua").lsp_document_symbols()
    -- end, opts)
    -- vim.keymap.set("n", "<leader>fw", function()
    --     require("fzf-lua").lsp_workspace_symbols()
    -- end, opts)
    -- vim.keymap.set("n", "<leader>fi", function()
    --     require("fzf-lua").lsp_implementations()
    -- end, opts)

    if client:supports_method("textDocument/codeAction", bufnr) then
        -- vim.keymap.set("n", "<leader>oi", function()
        --     vim.lsp.buf.code_action({
        --         context = { only = { "source.organizeImports" }, diagnostics = {} },
        --         apply = true,
        --         bufnr = bufnr,
        --     })
        --     vim.defer_fn(function()
        --         vim.lsp.buf.format({ bufnr = bufnr })
        --     end, 50)
        -- end, opts)
    end
end

vim.api.nvim_create_autocmd("LspAttach", { group = user_config_group, callback = lsp_on_attach })

-- AutoCMDs

-- Format on save (ONLY real file buffers)
vim.api.nvim_create_autocmd("BufWritePre", {
    group = user_config_group,
    pattern = {
        "*.lua",
        "*.py",
        "*.go",
        "*.js",
        "*.jsx",
        "*.ts",
        "*.tsx",
        "*.json",
        "*.css",
        "*.scss",
        "*.html",
        "*.sh",
        "*.bash",
        "*.zsh",
        "*.c",
        "*.cpp",
        "*.h",
        "*.hpp",
    },
    callback = function(args)
        -- avoid formatting non-file buffers (helps prevent weird write prompts)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end
        if not vim.bo[args.buf].modifiable then
            return
        end
        if vim.api.nvim_buf_get_name(args.buf) == "" then
            return
        end

        pcall(vim.lsp.buf.format, {
            bufnr = args.buf,
            timeout_ms = 2000,
        })
    end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = user_config_group,
    callback = function()
        vim.hl.on_yank()
    end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
    group = user_config_group,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = user_config_group,
    desc = "Restore last cursor position",
    callback = function()
        if vim.o.diff then -- except in diff mode
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
        local last_line = vim.api.nvim_buf_line_count(0)

        local row = last_pos[1]
        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})
