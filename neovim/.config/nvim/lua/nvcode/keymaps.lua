function noremap(mode, key, command)
    local options = {noremap=true, silent=true}
    return vim.api.nvim_set_keymap(mode, key, command, options)
end

-- ctrl+p to open file
noremap("n", "<C-p>", "<CMD>lua require('nvcode.plugins.telescope').project_files()<CR>")
noremap("n", "<C-t>", "<CMD>Telescope buffers<CR>")

-- ctrl+b to toggle file explorer
noremap("n", "<C-b>", "<CMD>NvimTreeToggle<CR>")
noremap("t", "<C-b>", "<CMD>NvimTreeToggle<CR>")

-- ctrl+j to toggle terminal
noremap("n", "<C-j>", "<CMD>ToggleTerm<CR>")
noremap("t", "<C-j>", "<CMD>ToggleTerm<CR>")
noremap("t", "<esc>", "<CMD>ToggleTerm<CR>")
