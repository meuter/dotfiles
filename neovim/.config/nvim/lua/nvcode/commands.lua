vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
vim.cmd [[ command! Close execute 'Bd' ]]
vim.cmd [[ command! CloseAll execute ':bufdo Bd' ]]
vim.cmd [[ command! CloseAllExceptCurrent execute '%bd|e#|bd#' ]]
