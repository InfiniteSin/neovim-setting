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
    completefunc = 'v:lua.vim.lsp.omnifunc',
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
vim.opt.path:append('**')

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

-- Key Mapping
local map = vim.keymap.set
local map_option = { noremap = true, silent = true }
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader><leader>x', '<cmd>source %<CR>')
map('n', '<leader>x', ':.lua<CR>')
map('v', '<leader>x', ':lua<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>qq', ':quit<CR>')
map('n', '<leader>s', ':e .<CR>')    -- edit current directory
map('n', '<leader>S', ':vnew .<CR>') -- edit current directory with vertical split window
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
-- keep visual select area when indent(gv: go to last visual block)
map('v', '<', '<gv', { noremap = true, silent = true })
map('v', '>', '>gv', { noremap = true, silent = true })
-- move line up/down in visual mode
map('v', '<M-j>', ":m '>+1<CR>gv=gv", map_option)
map('v', '<M-k>', ":m '<-2<CR>gv=gv", map_option)
