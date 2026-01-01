vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.encoding = 'UTF-8'

local opts = vim.opt
local opts_tbl = {
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
  -- completefunc = 'v:lua.vim.lsp.omnifunc',
  -- wildmenu = true,
  pumheight = 10, -- show at most 10 options
  -- UI
  background = "dark",
  termguicolors = true,
  winborder = "rounded",
}
for key, value in pairs(opts_tbl) do
  opts[key] = value
end
