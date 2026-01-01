local languages_tbl = { 'ruby' }
local M = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.config',         -- Sets main module to use for opts
  -- [[ Configure Treesitter ]]
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'python',
      'sql',
      },
      auto_install = true,                  -- auto install parsers
      highlight = {
        enable = true,
        -- some languages depend on vim's regex hgihlighting system
        -- if experienceing weird indenting issues, add these languages
        -- to additional_vim_regex_highlighting and disabled indent
        -- etc: ruby
        additional_vim_regex_highlighting = languages_tbl,
        },
      indent = { enalbe = true, disable = languages_tbl },
    },
    -- Additional modules can config
    -- Incremental selection: see `:h nvim-treesitter-incremental-selection-mod`
    -- Context: https://github.com/nvim-treesitter/nvim-treesitter-context
    -- Textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  }
return M
