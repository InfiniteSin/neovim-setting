-- Use built-in vim.pack to manage plugins (experimental, Neovim 0.12+)
-- Each module under lua/plugins/ is self-contained: it registers its plugin
-- with vim.pack.add() and configures it.

require('plugins.fzf')
require('plugins.oil')
require('plugins.gitsigns')
require('plugins.treesitter')
require('plugins.lsp')
