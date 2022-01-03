local noremap = require("user.helpers").noremap

-- ctrl+p to open file
noremap("n", "<C-p>", "<CMD>lua require('user.helpers').project_files()<CR>")
noremap("n", "<C-t>", "<CMD>Telescope buffers<CR>")

-- ctrl+b to toggle file explorer
noremap("n", "<C-b>", "<CMD>NvimTreeToggle<CR>")

-- ctrl+j to toggle terminal
noremap("n", "<C-j>", "<CMD>NeotermToggle<CR>")
noremap("t", "<C-j>", "<CMD>NeotermToggle<CR>")

