local map = vim.keymap.set
local map_opts = {
  noremap = true,
  silent = true,
}



-- fzf
local builtin = require('telescope.builtin')
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

