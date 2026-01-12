local M = {
  -- Fuzzy Find
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      -- Native FZF sorter and fzf syntax support
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
}
return M
