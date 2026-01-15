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
  config = function()
    require('telescope').setup({
      pickers = {
        find_files = {
          theme = 'ivy',
        },
      },
      extensions = {
        fzf = {},
      },
    })

    -- load fzf syntax extension
    require('telescope').load_extension('fzf')

    -- keymaps
    local builtin = require('telescope.builtin')
    local map = vim.keymap.set

    map('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles - [FZF]' })
    map('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp - [FZF]' })
    map('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps - [FZF]' })
    map('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord - [FZF]' })
    map('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep - [FZF]' })
    map('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics - [FZF]' })
    map('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers - [FZF]' })
    map('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files - [FZF]' })
    map('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume - [FZF]' })
    map('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope - [FZF]' })
    map('n', '<leader>f/', function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      })
    end, { desc = '[F]ind [/] in Open Files' })
    map('n', '<leader>en', function()
      builtin.find_files({
        cmd = vim.fn.stdpath('config')
      })
    end, { desc = '[E]nvironment Config' })
    map('n', '<leader>ep', function()
      builtin.find_files({
        cmd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
      })
    end, { desc = '[E]nvironment Plugins' })

  end,
}
return M
