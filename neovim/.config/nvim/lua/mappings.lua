local map = vim.api.nvim_set_keymap

-- ctrl+p to open file
map("n", "<C-p>", "<CMD>lua require('project-files').project_files()<CR>", {noremap=true, silent=true})
map("n", "<C-t>", "<CMD>Telescope buffers<CR>", {noremap=true, silent=true})

-- ctrl+b to toggle file explorer
map("n", "<C-b>", "<CMD>NvimTreeToggle<CR>", {noremap=true, silent=true})

-- ctrl+j to toggle terminal
map("n", "<C-j>", "<CMD>NeotermToggle<CR>", {noremap=true, silent=true})
map("t", "<C-j>", "<CMD>NeotermToggle<CR>", {noremap=true, silent=true})

