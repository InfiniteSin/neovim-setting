vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.encoding = 'UTF-8'

-- Editor
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.showtabline = 2       -- always show tabline
vim.opt.showmode = true       -- always show current vim mode
vim.opt.number = true         -- use line number
vim.opt.relativenumber = true -- use relative line number
vim.opt.cursorline = true     -- highlight current line
vim.opt.signcolumn = "yes"    -- left 1 column to show any sign
vim.opt.colorcolumn = "80"    -- column length reference
-- cmdheight = 2 -- higher command area
vim.opt.wrap = false          -- disable auto line wrap
vim.opt.linebreak = true      -- wrap line in convenient points only in display
-- hidden = true -- hidden modified buffers
vim.opt.list = true           -- show invisible characters
vim.opt.mouse = "a"           -- enable mouse
vim.opt.splitbelow = true     -- open new vertical split tab below
vim.opt.splitright = true     -- open new horizontal split tab right
vim.opt.updatetime = 300      -- status update time
vim.opt.timeoutlen = 500      -- keyboard react time 500 ms
-- Indent
vim.opt.tabstop = 4           -- 1 Tab == 4 Spaces
vim.opt.softtabstop = 4
vim.opt.shiftround = true     -- round indent
vim.opt.shiftwidth = 4        -- moving space when using >> and <<
vim.opt.expandtab = true      -- use spaces instead of tab
vim.opt.autoindent = true     -- auto indent next line
vim.opt.smartindent = true
-- Search
vim.opt.ignorecase = true -- ignore case sensetive
vim.opt.smartcase = true  -- case sensetive only with capital word
vim.opt.incsearch = true  -- search with characters input
-- File
vim.opt.autoread = true   -- auto load file when was change outside
vim.opt.undofile = true
-- Backup
vim.opt.backup = false -- disable backup
vim.opt.writebackup = false
vim.opt.swapfile = false
-- Clipboard
-- Only set clipboard if not in ssh to make sure the OSC 52
-- integration works automatically
-- Sync with system clipboard
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
-- Complete Option Menu
vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect", -- donot auto select complete option
  "noinsert", -- do not auto insert complete option
  "popup",
}
-- completefunc = 'v:lua.vim.lsp.omnifunc'
-- wildmenu = true
vim.opt.pumheight = 10 -- show at most 10 options
-- UI
vim.opt.background = "dark"
vim.opttermguicolors = true
vim.optwinborder = "rounded"
