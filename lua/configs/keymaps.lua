local map = vim.keymap.set
local map_option = { noremap = true, silent = true }
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader><leader>x', '<cmd>source %<CR>')
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
-- keep visual select area when indent(gv: go to last visual block)
map('v', '<', '<gv', { noremap = true, silent = true })
map('v', '>', '>gv', { noremap = true, silent = true })
-- move line up/down in visual mode
map('v', '<M-j>', ":m '>+1<CR>gv=gv", map_option)
map('v', '<M-k>', ":m '<-2<CR>gv=gv", map_option)
-- Netrw
map('n', '-', ':Rexplore<CR>')
