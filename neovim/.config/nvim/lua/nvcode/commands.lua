vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
vim.cmd [[ command! Close execute 'Bd' ]]
vim.cmd [[ command! CloseAll execute ':bufdo Bd' ]]
vim.cmd [[ command! CloseAllExceptCurrent execute '%bd|e#|bd#' ]]

vim.cmd [[ command! GitHistory execute 'Telescope git_commits' ]]
vim.cmd [[ command! GitFileHistory execute 'Telescope git_bcommits' ]]
vim.cmd [[ command! GitBranch execute 'Telescope git_branches' ]]
vim.cmd [[ command! GitStatus execute 'Telescope git_status' ]]

vim.cmd [[ command! Todo execute 'lua require("nvcode.plugins.telescope").search_todo()' ]]
vim.cmd [[ command! SearchAndReplace execute 'lua require("nvcode.plugins.telescope").search_and_replace()' ]]
