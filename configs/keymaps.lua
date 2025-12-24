local map = vim.keymap.set
local map_option = { noremap = true, silent = true }
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader><leader>x', '<cmd>source %<CR>')
map('n', '<leader>x', ':.lua<CR>')
map('v', '<leader>x', ':lua<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>qq', ':quit<CR>')
map('n', '<leader>s', ':e .<CR>')    -- edit current directory
map('n', '<leader>S', ':vnew .<CR>') -- edit current directory with vertical split window
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
-- keep visual select area when indent(gv: go to last visual block)
map('v', '<', '<gv', { noremap = true, silent = true })
map('v', '>', '>gv', { noremap = true, silent = true })
-- move line up/down in visual mode
map('v', '<M-j>', ":m '>+1<CR>gv=gv", map_option)
map('v', '<M-k>', ":m '<-2<CR>gv=gv", map_option)
