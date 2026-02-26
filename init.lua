-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
-- Global Settings
local g = vim.g
local options_g = {
    encoding = "UTF-8", -- use utf-8 file encode
    mapleader = " ",
    maplocalleader = " ",
}
for key, value in pairs(options_g) do
    g[key] = value
end

local opt = vim.opt
local options_opt = {
    -- Editor
    scrolloff = 8,
    sidescrolloff = 8,
    showtabline = 2,        -- always show tabline
    showmode = true,        -- always show current vim mode
    number = true,          -- use line number
    relativenumber = true,  -- use relative line number
    cursorline = true,      -- highlight current line
    signcolumn = "yes:3",   -- left 1 column to show any sign
    colorcolumn = "80",     -- column length reference
    -- cmdheight = 2,               -- higher command area
    wrap = false,           -- disable auto line wrap
    whichwrap = "<,>,[,]",
    linebreak = true,       -- wrap line in convenient points only in display
    -- hidden = true,       -- hidden modified buffers
    list = true,            -- show invisible characters
    showmatch = true,       -- highlight match brackets
    mouse = "a",            -- enable mouse support
    showmode = false,       -- do not show current mode
    splitbelow = true,      -- open new vertical split tab below
    splitright = true,      -- open new horizontal split tab right
    updatetime = 300,       -- status update time
    timeoutlen = 500,       -- keyboard react time 500 ms
    lazyredraw = true,      -- do not redraw during macros
    errorbells = false,     -- no error sounds
    -- better backspace behaviour
    backspace = "indent,eol,start",
    selection = "inclusive",-- include last char in selection
    redrawtime = 10000,     -- increase neovim redraw tolerance
    maxmempattern = 20000,  -- increase max memory
    -- Markup
    conceallevel = 0,       -- do not hide markup
    concealcursor = "",     -- do not hide cursorline in markup
    -- Indent
    tabstop = 4,            -- 1 Tab == 4 Spaces
    softtabstop = 4,
    shiftround = true,      -- round indent
    shiftwidth = 4,         -- moving space when using >> and <<
    expandtab = true,       -- use spaces instead of tab
    autoindent = true,      -- auto indent next line
    smartindent = true,
    -- Search
    hlsearch = true,        -- highlight search result
    ignorecase = true,      -- ignore case sensetive
    smartcase = true,       -- case sensetive only with capital word
    incsearch = true,       -- search with characters input
    -- File
    autoread = true,        -- auto load file when was change outside
    autowrite = false,      -- diable auto-save
    undofile = true,
    autochdir = false,      -- do not autochange dirs
    -- Backup
    backup = false,         -- disable backup
    writebackup = false,
    swapfile = false,       -- disable swapfile
    -- Complete Option Menu
    completeopt = {
        "menu",
        "menuone",
        "noselect",           -- do not auto select complete option
        "noinsert",           -- do not auto insert complete option
        "popup",
    },
    -- completefunc = 'v:lua.vim.lsp.omnifunc',
    -- tab completion
    wildmenu = true,
    -- complete longest common match, full completion list, cycle through tabs
    wildmode = "longest:full,full",
    pumheight = 10,         -- show at most 10 options
    -- UI
    background = "dark",
    termguicolors = true,
    winborder = "rounded",
    fillchars = {
        eob = " ",          -- hide "~" on empty lines
    },
    tabline = "%t",
    -- LSP
    synmaxcol = 300,        -- syntax highlighting limit
    -- Buffers
    hidden = true,          -- allow hidden buffers
    modifiable = true,      -- allow buffer modifications
}

for key, value in pairs(options_opt) do
    opt[key] = value
end
vim.opt.path:append('**')   -- include subdirs in search
-- include - in words
vim.opt.iskeyword:append("-")
-- use system clipboard
vim.opt.clipboard:append("unnamedplus")
-- improve diff display
vim.opt.diffopt:append("linematch:60")

vim.diagnostic.config({
    underline = false,
    virtual_text = { prefix = "●", spacing = 4 },
    update_in_insert = false,
    severity_sort =true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
        },
    },
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        focusable = false,
        style = "minimal",
    },
})

----------------------------------------------------------------------------
-- User Define Functions
----------------------------------------------------------------------------

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




----------------------------------------------------------------------------
-- Plugins
----------------------------------------------------------------------------

vim.pack.add({
    -- git
    "https://www.github.com/lewis6991/gitsigns.nvim",
    -- collections of qol plugins
    "https://www.github.com/echasnovski/mini.nvim",
    -- fuzzy find
    "https://github.com/ibhagwan/fzf-lua",
    -- AST enhanced
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
    },
    -- file tree
    "https://github.com/stevearc/oil.nvim",
    -- Language Server Protocols
    "https://www.github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    -- Autocomplete
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("1.*"),
    },
    "https://github.com/L3MON4D3/LuaSnip",

})


local function packadd(name)
    vim.cmd("packadd " .. name)
end

-- Git
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


-- Oil
vim.keymap.set("n", "-", function()
    local plugin = require("oil")
    plugin.setup({
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
    })
    vim.cmd("Oil")
end, { desc = "Oil File Tree" })



-- Treesitter

local setup_treesitter = function()
    local treesitter = require("nvim-treesitter")
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

    local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        once = true,
        callback = function(args)
            if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
                vim.treesitter.start(args.buf)
            end
        end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function()
            if vim.opt.foldmethod:get() ~= 'manual' then
                -- open all fold
                vim.cmd('normal zR')
            end
        end,
    })
end
setup_treesitter()

-- use expression for folding, need tree-sitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Fuzzy Finder

require('fzf-lua').setup({})

-- Fuzzy Finder Keymaps

vim.keymap.set("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "Find Live Grep" })
vim.keymap.set("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fq", function() require("fzf-lua").quickfix() end, { desc = "Find QuickFix" })
vim.keymap.set("n", "<leader>fl", function() require("fzf-lua").loclist() end, { desc = "Find Locationlist" })
vim.keymap.set("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "Find Helps" })
vim.keymap.set("n", "<leader>f=", function() require("fzf-lua").keymaps() end, { desc = "Find Keymaps" })
vim.keymap.set("n", "<leader>fx", function() require("fzf-lua").diagnostics_document() end, { desc = "Find Diagnostic Document" })
vim.keymap.set("n", "<leader>fX", function() require("fzf-lua").diagnostics_workspace() end, { desc = "Find Diagnostic Workspace" })

-- LSP
packadd("nvim-lspconfig")
require("mason").setup({})


-- Autocomplete
packadd("blink.cmp")
packadd("LuaSnip")


-- Utils
require("mini.icons")
require("mini.surround")
require("mini.comment")


----------------------------------------------------------------------------
-- Keymaps
----------------------------------------------------------------------------

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
    return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
    return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })


-- clear search highlight
vim.keymap.set("n", "<Esc>", "<Cmd>nohl<CR>",
{ 
    remap = true,
    silent = true,
    nowait = true,
    desc = "Clear search highlights",
})

-- better search display
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- better page navigator
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- buffer cycle
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- better window navigator
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- better selection movement
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- better indent control
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- better "J" behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })


----------------------------------------------------------------------------
-- AutoCMDS
----------------------------------------------------------------------------

local user_config_group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
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


