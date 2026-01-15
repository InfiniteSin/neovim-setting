local M = {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('oil').setup({
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<M-h>'] = 'actions.select.split',
      },
      view_options = {
        show_hidden = true,
      },
    })

    -- Open Parrent Directory in Current Window
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Parent Dir' })
    -- Open Parrent Directory in Float Window
    vim.keymap.set('n', '<leader>-', require('oil').toggle_float)
  end,
}
return M
