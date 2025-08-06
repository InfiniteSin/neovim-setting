-- Global Settings
local g = vim.g
local options_g = {
    encoding = "UTF-8", -- use utf-8 file encode
    mapleader = " ",
    maplocalleader = "\\",
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
    showtabline = 2, -- always show tabline
    showmode = true, -- always show current vim mode
    number = ture, -- use line number
    relativenumber = true, -- use relative line number
    cursorline = true, -- highlight current line
    -- signcolumn = "yes", -- left 1 column to show any sign
    colorcolumn = "80", -- column length reference
    -- cmdheight = 2, -- higher command area
    wrap = false, -- disable auto line wrap
    linebreak = true, -- wrap line in convenient points only in display
    -- hidden = true, -- hidden modified buffers
    list = true, -- show invisible characters
    mouse = "a", -- enable mouse
    splitbelow = true, -- open new vertical split tab below
    splitright = true, -- open new horizontal split tab right
    updatetime = 300, -- status update time
    timeoutlen = 500, -- keyboard react time 500 ms
    
    -- Indent
    tabstop = 4, -- 1 Tab == 4 Spaces
    softtabstop = 4,
    shiftround = true, -- round indent
    shiftwidth = 4, -- moving space when using >> and <<
    expandtab = true, -- use spaces instead of tab
    autoindent = true, -- auto indent next line
    smartindent = true,
    
    -- Search
    ignorecase = true, -- ignore case sensetive
    smartcase = true, -- case sensetive only with capital word
    incsearch = true, -- search with characters input
    
    -- File
    autoread = true, -- auto load file when was change outside
    
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
    },
    -- wildmenu = true,
    pumheight = 10, -- show at most 10 options
    
    -- UI
    background = "dark",
    termguicolors = true,
    
}
for key, value in pairs(options_opt) do
    opt[key] = value
end

local o = vim.o
local options_o = {
    whichwrap = "<,>,[,]", -- when cursor in front/end of line,use <Left>/<Right> jump to next line
    listchars = "space:.", -- display . instead of spaces
}
for key, value in pairs(options_o) do
    o[key] = value
end

-- Buffer Scope Options
local bo = vim.bo
local options_bo = {
    -- Indent
    tabstop = 4,
    expandtab = true, -- use spaces instead of tab
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
