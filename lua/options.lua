-- Global Settings
local g = vim.g
local options_g = {
  encoding = "UTF-8", -- use utf-8 file encode
  mapleader = " ",
  maplocalleader = " ",
  python3_host_prog = "G:/Code/pyneovim/.venv/Scripts/python",
}
for key, value in pairs(options_g) do
  g[key] = value
end

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
  signcolumn = "yes:3",  -- left 1 column to show any sign
  colorcolumn = "80",    -- column length reference
  -- cmdheight = 2,               -- higher command area
  wrap = false,          -- disable auto line wrap
  whichwrap = "<,>,[,]",
  linebreak = true,      -- wrap line in convenient points only in display
  -- hidden = true,       -- hidden modified buffers
  list = true,           -- show invisible characters
  showmatch = true,      -- highlight match brackets
  mouse = "a",           -- enable mouse support
  showmode = false,      -- do not show current mode
  splitbelow = true,     -- open new vertical split tab below
  splitright = true,     -- open new horizontal split tab right
  updatetime = 300,      -- status update time
  timeoutlen = 500,      -- keyboard react time 500 ms
  lazyredraw = true,     -- do not redraw during macros
  errorbells = false,    -- no error sounds
  -- better backspace behaviour
  backspace = "indent,eol,start",
  selection = "inclusive", -- include last char in selection
  redrawtime = 10000,      -- increase neovim redraw tolerance
  maxmempattern = 20000,   -- increase max memory
  -- Markup
  conceallevel = 0,        -- do not hide markup
  concealcursor = "",      -- do not hide cursorline in markup
  -- Indent
  tabstop = 4,             -- 1 Tab == 4 Spaces
  softtabstop = 4,
  shiftround = true,       -- round indent
  shiftwidth = 4,          -- moving space when using >> and <<
  expandtab = true,        -- use spaces instead of tab
  autoindent = true,       -- auto indent next line
  smartindent = true,
  -- Search
  hlsearch = true,   -- highlight search result
  ignorecase = true, -- ignore case sensetive
  smartcase = true,  -- case sensetive only with capital word
  incsearch = true,  -- search with characters input
  -- File
  autoread = true,   -- auto load file when was change outside
  autowrite = false, -- diable auto-save
  undofile = true,
  autochdir = false, -- do not autochange dirs
  -- Backup
  backup = false,    -- disable backup
  writebackup = false,
  swapfile = false,  -- disable swapfile
  -- Complete Option Menu
  completeopt = {
      "menu",
      "menuone",
      "noselect", -- do not auto select complete option
      "noinsert", -- do not auto insert complete option
      "popup",
  },
  -- completefunc = 'v:lua.vim.lsp.omnifunc',
  -- tab completion
  wildmenu = true,
  -- complete longest common match, full completion list, cycle through tabs
  wildmode = "longest:full,full",
  pumheight = 10, -- show at most 10 options
  -- UI
  background = "dark",
  termguicolors = true,
  winborder = "rounded",
  fillchars = {
      eob = " ", -- hide "~" on empty lines
  },
  tabline = "%t",
  -- LSP
  synmaxcol = 300,   -- syntax highlighting limit
  -- Buffers
  hidden = true,     -- allow hidden buffers
  modifiable = true, -- allow buffer modifications
}

for key, value in pairs(options_opt) do
  opt[key] = value
end
vim.opt.path:append('**') -- include subdirs in search
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
  severity_sort = true,
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
