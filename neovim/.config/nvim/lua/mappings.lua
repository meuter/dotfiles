local map = vim.api.nvim_set_keymap

map("n", "<C-p>", "<CMD>lua require('project-files').project_files()<CR>", {noremap = true, silent = true})