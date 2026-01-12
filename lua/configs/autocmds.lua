vim.api.nvim_create_user_command('SearchNvimConf', function()
  require('telescope.builtin').find_files({
    cwd = vim.fn.stdpath('config'),
  })
end, {
  desc = 'Find Neovim Configuration Files',
})
