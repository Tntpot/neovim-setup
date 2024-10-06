local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', function() builtin.find_files { find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }} end)
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>sp', builtin.live_grep, { desc = 'Telescope Live Grep' })
-- vim.keymap.set('n', '<leader>sp', function()
-- 	builtin.grep_string({ search = vim.fn.input("Grep > ") });
-- end)
