local function noremap(mode, key, command)
    local options = {noremap=true, silent=true}
    return vim.api.nvim_set_keymap(mode, key, command, options)
end

local function remap_all_modes(key, command)
    noremap("n", key, command)
    noremap("i", key, "<C-\\><C-N>" .. command)
    noremap("v", key, "<C-\\><C-N>" .. command)
end

-- ctrl+p to open file
remap_all_modes("<C-p>", "<CMD>lua require('nvcode.plugins.telescope').project_files()<CR>")

-- ctrl+t to open a buffer 
remap_all_modes("<C-t>", "<CMD>Telescope buffers<CR>")

-- ctrl+g to open git fugitive
remap_all_modes("<C-g>", "<CMD>Git<CR>")

-- ctrl+b to toggle file explorer
remap_all_modes("<C-b>", "<CMD>NvimTreeToggle<CR>")

-- ctrl+j to toggle terminal
remap_all_modes("<C-j>", "<CMD>ToggleTerm<CR>")
noremap("t", "<esc>", "<CMD>ToggleTerm<CR>")

-- keep visual mode when indenting/dedenting
noremap("v", "<S-Tab>", "<gv")
noremap("v", "<Tab>", ">gv")
