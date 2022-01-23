vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
vim.cmd [[ command! Close execute 'Bd' ]]
vim.cmd [[ command! CloseAll execute ':bufdo Bd' ]]
vim.cmd [[ command! CloseAllExceptCurrent execute '%bd|e#|bd#' ]]

vim.cmd [[ command! GitHistory execute 'Telescope git_commits' ]]
vim.cmd [[ command! GitFileHistory execute 'Telescope git_bcommits' ]]
vim.cmd [[ command! GitBranch execute 'Telescope git_branches' ]]
vim.cmd [[ command! GitStatus execute 'Telescope git_status' ]]

vim.cmd [[ command! ConvertHexStringLineToCArray execute 'lua require("nvcode.misc.hexconvert").convert_hexstring_current_line_to_c_array()' ]]
vim.cmd [[ command! ConvertHexStringSelectionToCArray execute 'lua require("nvcode.misc.hexconvert").convert_hexstring_selection_to_c_array()' ]]

vim.cmd [[ command! SearchAndReplace execute 'lua require("nvcode.misc.searchreplace").search_and_replace()' ]]

vim.cmd [[ command! Todo execute 'lua require("nvcode.plugins.telescope").search_todo()' ]]
vim.cmd [[ command! ProjectFiles execute 'lua require("nvcode.plugins.telescope").project_files()<CR>' ]]
vim.cmd [[ command! Navigate execute 'lua require("nvcode.plugins.telescope").navigate()<CR>' ]]
vim.cmd [[ command! SearchWordUnderCursor execute 'lua require("nvcode.plugins.telescope").search_word_under_cursor()' ]]
vim.cmd [[ command! SearchSelectedText execute 'lua require("nvcode.plugins.telescope").search_selected_text()' ]]
vim.cmd [[ command! SearchFunction execute 'lua require("nvcode.plugins.telescope").search_function()' ]]

vim.cmd [[ command! ToggleMouseCopy execute 'lua require("nvcode.plugins.ui.indentline").toggle_mouse_copy()<CR>' ]]
