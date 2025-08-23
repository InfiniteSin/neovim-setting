-- Global Settings
local g = vim.g
local options_g = {
    encoding = "UTF-8", -- use utf-8 file encode
    mapleader = " ",
    -- maplocalleaderkey = "\\",
    maplocalleader = " ",
    python3_host_prog = "G:/Code/pyneovim/.venv/Scripts/python",
}
for key, value in pairs(options_g) do
    g[key] = value
end

-- Options, vim.opt equal as vim.o
local opt = vim.opt
local options_opt = {
    -- Editor
    scrolloff = 8,
    sidescrolloff = 8,
    showtabline = 2,       -- always show tabline
    showmode = true,       -- always show current vim mode
    number = true,         -- use line number
    relativenumber = true, -- use relative line number
    cursorline = true,     -- highlight current line
    signcolumn = "yes",    -- left 1 column to show any sign
    colorcolumn = "80",    -- column length reference
    -- cmdheight = 2, -- higher command area
    wrap = false,          -- disable auto line wrap
    linebreak = true,      -- wrap line in convenient points only in display
    -- hidden = true, -- hidden modified buffers
    list = true,           -- show invisible characters
    mouse = "a",           -- enable mouse
    splitbelow = true,     -- open new vertical split tab below
    splitright = true,     -- open new horizontal split tab right
    updatetime = 300,      -- status update time
    timeoutlen = 500,      -- keyboard react time 500 ms
    -- Indent
    tabstop = 4,           -- 1 Tab == 4 Spaces
    softtabstop = 4,
    shiftround = true,     -- round indent
    shiftwidth = 4,        -- moving space when using >> and <<
    expandtab = true,      -- use spaces instead of tab
    autoindent = true,     -- auto indent next line
    smartindent = true,
    -- Search
    ignorecase = true, -- ignore case sensetive
    smartcase = true,  -- case sensetive only with capital word
    incsearch = true,  -- search with characters input
    -- File
    autoread = true,   -- auto load file when was change outside
    undofile = true,
    -- Backup
    backup = false, -- disable backup
    writebackup = false,
    swapfile = false,
    -- Clipboard
    -- Only set clipboard if not in ssh, to make sure the OSC 52
    -- integration works automatically
    -- Sync with system clipboard
    clipboard = vim.env.SSH_TTY and "" or "unnamedplus",
    -- Complete Option Menu
    completeopt = {
        "menu",
        "menuone",
        "noselect", -- donot auto select complete option
        "noinsert", -- do not auto insert complete option
        "popup",
    },
    -- wildmenu = true,
    pumheight = 10, -- show at most 10 options
    -- UI
    background = "dark",
    termguicolors = true,
    winborder = "rounded",
}
for key, value in pairs(options_opt) do
    opt[key] = value
end

_G.get_mode = function()
    local map = {
        ['n']     = 'NORMAL',
        ['no']    = 'O-PENDING',
        ['nov']   = 'O-PENDING',
        ['noV']   = 'O-PENDING',
        ['no\22'] = 'O-PENDING',
        ['niI']   = 'NORMAL',
        ['niR']   = 'NORMAL',
        ['niV']   = 'NORMAL',
        ['nt']    = 'NORMAL',
        ['ntT']   = 'NORMAL',
        ['v']     = 'VISUAL',
        ['vs']    = 'VISUAL',
        ['V']     = 'V-LINE',
        ['Vs']    = 'V-LINE',
        ['\22']   = 'V-BLOCK',
        ['\22s']  = 'V-BLOCK',
        ['s']     = 'SELECT',
        ['S']     = 'S-LINE',
        ['\19']   = 'S-BLOCK',
        ['i']     = 'INSERT',
        ['ic']    = 'INSERT',
        ['ix']    = 'INSERT',
        ['R']     = 'REPLACE',
        ['Rc']    = 'REPLACE',
        ['Rx']    = 'REPLACE',
        ['Rv']    = 'V-REPLACE',
        ['Rvc']   = 'V-REPLACE',
        ['Rvx']   = 'V-REPLACE',
        ['c']     = 'COMMAND',
        ['cv']    = 'EX',
        ['ce']    = 'EX',
        ['r']     = 'REPLACE',
        ['rm']    = 'MORE',
        ['r?']    = 'CONFIRM',
        ['!']     = 'SHELL',
        ['t']     = 'TERMINAL',
    }
    local mode_code = vim.api.nvim_get_mode().mode
    if map[mode_code] == nil then
        return mode_code
    end
    return map[mode_code]
end
local o = vim.o
local options_o = {
    whichwrap = "<,>,[,]", -- when cursor in front/end of line,use <Left>/<Right> jump to next line
    listchars = "space:.", -- display . instead of spaces
    tabline = "%t",        -- tabline
    -- Statusline
    statusline = table.concat({
        "[--%{v:lua.get_mode()}--]",
        "%F%m",
        "%t%(%r%h%w%q%)",
        "%=",
        "[Buffer %n]",
        "%y",
        "[Line:%l|%L]",
        "[Col:%v|%c]",
        "%4p%%",
        "    "
    }, " ")
}
for key, value in pairs(options_o) do
    o[key] = value
end

-- Buffer Scope Options
local bo = vim.bo
local options_bo = {
    -- Indent
    tabstop = 4,
    expandtab = true,  -- use spaces instead of tab
    autoindent = true, -- auto indent next line

    -- File
    autoread = true, -- auto load file when was change outside
}
for key, value in pairs(options_bo) do
    bo[key] = value
end

-- Window Scope Options
local wo = vim.wo
local options_wo = {
}
for key, value in pairs(options_wo) do
    wo[key] = value
end

-- Plugin manage with native vim.pack
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/echasnovski/mini.icons" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main",
    },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
})

-- Key Mapping
local map = vim.keymap.set
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader><leader>x', '<cmd>source %<CR>')
map('n', '<leader>x', ':.lua<CR>')
map('v', '<leader>x', ':lua<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>qq', ':quit<CR>')
map('n', '<leader>s', ':e .<CR>')  -- edit current directory
map('n', '<leader>S', ':sf .<CR>') -- edit current directory with split window
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
-- open terminal in split window below
local job_id = 0
map("n", "<leader>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 5)
    vim.cmd("startinsert")

    job_id = vim.bo.channel
end)

map("n", "<space>run", function()
    vim.fn.chansend(job_id, {
        "python -v\r\n",
    })
end)

map("t", "<esc><esc>", '<C-\\><C-N>')
-- cancel highlight after search
map("n", "<esc><esc>", function()
    vim.cmd(":nohlsearch")
end)
-- Edit code parent directory
map("n", "<leader>er", ':e G:/Code<CR>')
-- Edit config directory
map("n", "<leader>ec", ':e D:/configs/configs<CR>')
-- Quickfix
map("n", "<M-j>", "<cmd>cnext<CR>")
map("n", "<M-k>", "<cmd>cprev<CR>")
map("n", "<M-o>", "<cmd>copen<CR>")
map("n", "<M-c>", "<cmd>cclose<CR>")
-- Buffer
-- map("n", "<leader>q", ":bd!<CR>", { silent = true })


-- User Command
vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
end, {})

-- Colorscheme
require("vague").setup({ transparent = true })
vim.cmd("colorscheme vague")
-- vim.cmd(":hi statusline guibg=NONE")

-- Plugin Key Mapping
map('n', '<leader>ff', ":Pick files<CR>")
map('n', '<leader>fh', ":Pick help<CR>")
map('n', '<leader>fb', ":Pick buffers<CR>")
map('n', '<leader>fg', ":Pick grep<CR>")
map('n', '-', ":Oil<CR>")
map('t', '', "")
map('t', '', "")
map('n', '<leader>lf', vim.lsp.buf.format)

-- LSP Config
vim.lsp.enable({
    "lua_ls",
    "pylsp",
    "ruff",
})
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            },
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    },
    root_markers = { '.git' },
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- keymap for vim.lsp.buf.implementation
            map('n', 'gri', vim.lsp.buf.implementation)
        end
        -- enable auto-completion.
        -- Note: Use <C-y> to select an item
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocomplet on EVERY key press. Maybe slow!
            -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i))
            -- client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
        end
        -- Auto-format('lint') on save
        -- Usually not need if server supports 'textDocument/willSaveWaitUntil'
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = args.buf,
                        id = client.id,
                        timeout_ms = 1000
                    })
                end,
            })
        end
    end,
})
map('n', 'gdc', vim.lsp.buf.declaration)
map('n', 'gdf', vim.lsp.buf.definition)
-- default keymap from neovim Ver 11
-- map('n', 'grr', vim.lsp.buf.references)
-- map('n', 'grt', vim.lsp.buf.type_definition)
-- map('n', 'grn', vim.lsp.buf.rename)
-- map('n', 'gO', vim.lsp.buf.document_symbol)
-- map('n', 'gra', vim.lsp.buf.code_action)

-- Ruff
vim.lsp.config("ruff", {
    init_options = {
        settings = {
            -- ruff settings
            lint = {
                extendSelect = { "All" },
                ignore = {
                    "ERA001",
                    "T201",
                    "N802",
                    "N806",
                    "PLR2004",
                    "RET505",
                    "S101",
                },
            },
        },
    },
})
require("lspconfig").ruff.setup({
    init_options = {
        settings = {
            logLevel = "debug",
        },
    },
})
-- If install pyright
-- vim.api.nvim_create_autocmd("LspAttach", {
--     group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover",
--     {clear = true}),
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if client == nil then
--             return
--         end
--         if client.name == "ruff" then
--             -- Disable hover in faver of Pyright
--             client.server_capabilities.hoverProvider = false
--         end
--     end,
--     desc = "LSP: Disable hover capability from Ruff"
-- })
-- require("lspconfig").pyright.setup({
--     settings = {
--         pyright = {
--             -- Using Ruff's import organizer
--             disableOrganizeImports = true,
--         },
--         python = {
--             analysis = {
--                 -- Ignore all files for analysis to exclusively use Ruff for linting
--                 ignore = { "*" },
--             },
--         },
--     },
-- })


-- Plugin Init
require("mason").setup()
require("mini.icons").setup()
require("mini.pick").setup()
require("oil").setup()
require("nvim-treesitter").setup({
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "python",
        "query",
        "markdown",
        "markdown_inline",
    },
    highlight = { enable = true, },
})

-- Snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({
    paths = vim.fn.stdpath("config") .. "/snippets"
})
local ls = require("luasnip")
map("i", "<C-e>",
    function()
        ls.expand_or_jump(1)
    end,
    { silent = true })
-- map({ "i", "s" }, "<C-J>",
--     function()
--         ls.jump(1)
--     end,
--     { silent = true })
map({ "i", "s" }, "<C-K>",
    function()
        ls.jump(-1)
    end,
    { silent = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

-- Float Window and Float Terminal
local f_state = {
    floating = {
        buf = -1,
        win = -1,
    },
}
local create_float_window = function(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.width or math.floor(vim.o.lines * 0.8)

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - width) / 2)

    -- Create a buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_float_terminal = function()
    if not vim.api.nvim_win_is_valid(f_state.floating.win) then
        f_state.floating = create_float_window { buf = f_state.floating.buf }
        if vim.bo[f_state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
            vim.cmd("startinsert")
        end
        map("n", "q", function()
            vim.api.nvim_win_close(f_state.floating.win, true)
            vim.api.nvim_buf_delete(f_state.floating.buf, { force = true })
        end, { buffer = f_state.floating.buf })
    else
        vim.api.nvim_win_hide(f_state.floating.win)
    end
    -- Ensure buffer was delete when close window
    -- vim.api.nvim_create_autocmd("BufLeave", {
    --     buffer = f_state.floating.buf,
    --     callback = function()
    --         vim.api.nvim_buf_delete(f_state.floating.buf, { force = true })
    --     end,
    -- })
end

-- User Command for float window
vim.api.nvim_create_user_command("FloatWin", function()
    f_state.floating = create_float_window()
end, {})
-- User Command for float terminal
vim.api.nvim_create_user_command("FloatTerm", toggle_float_terminal, {})
map({ "n", "t" }, "<leader>tt", toggle_float_terminal)

-- User Command for clean unlist buffer
local clean_unlist_buf = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if not vim.api.nvim_buf_is_loaded(buf) then
            vim.cmd("bdelete " .. buf)
        end
    end
end
vim.api.nvim_create_user_command("ClearUnlistBuf", clean_unlist_buf, {})
map("n", "<leader>qb", clean_unlist_buf)
