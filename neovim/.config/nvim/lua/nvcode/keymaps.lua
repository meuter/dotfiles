local function noremap(mode, key, command)
    local options = {noremap=true, silent=true}
    return vim.api.nvim_set_keymap(mode, key, command, options)
end

local function remap_for_filetype(filetype, mode, key, command)
    vim.cmd("autocmd FileType " .. filetype .. " " .. mode .. "map <silent><buffer> " .. key .. " " .. command)
end

local function remap_all_modes(key, command)
    noremap("n", key, command)
    noremap("i", key, "<C-\\><C-N>" .. command)
    noremap("v", key, "<C-\\><C-N>" .. command)
end

-- ctrl+p to open file
remap_all_modes("<C-p>", "<CMD>lua require('nvcode.plugins.telescope').project_files()<CR>")

-- ctrl+t to select open a buffer
remap_all_modes("<C-t>", "<CMD>Telescope buffers<CR>")

-- ctrl+k for command pallette
remap_all_modes("<C-k>", "<CMD>Telescope commands<CR>")

-- ctrl+j for live grep search
remap_all_modes("<C-j>", "<CMD>Telescope live_grep<CR>")

-- ctrl+g to open git fugitive
remap_all_modes("<C-g>", "<CMD>Git<CR>")
remap_for_filetype("fugitive", "n", "<C-G>", "<CMD>q<CR>")
remap_for_filetype("fugitive", "n", "cc", "<CMD>q<bar>Git commit --quiet<CR>")

-- ctrl+b to toggle file explorer
remap_all_modes("<C-b>", "<CMD>NvimTreeToggle<CR>")
remap_all_modes("<F5>", "<CMD>NvimTreeRefresh<CR>")

-- ctrl+j to toggle terminal
remap_all_modes("<C-Y>", "<CMD>ToggleTerm<CR>")
noremap("t", "<esc>", "<CMD>ToggleTerm<CR>")
noremap("t", "<C-Y>", "<CMD>ToggleTerm<CR>")

-- keep visual mode when indenting/dedenting
noremap("v", "<Tab>", ">gv")
noremap("n", "<Tab>", "v><C-\\><C-N>")
noremap("v", "<S-Tab>", "<gv")
noremap("n", "<S-Tab>", "v<<C-\\><C-N>")

-- alt left,right to navigate jumplist
noremap("n", "<A-Left>", "<C-O>")
noremap("n", "<A-Right>", "<C-I>")

-- ctrl+l to toggle quick list
remap_all_modes("<C-l>", "<CMD>QToggle<CR>")
remap_for_filetype("qf", "n", "<CR>", "<CR><CMD>QToggle<CR>")

-- move lines around using alt+{up/down}
noremap("n", "<A-Down>", ":MoveLine(1)<CR>")
noremap("n", "<A-Up>", ":MoveLine(-1)<CR>")
noremap("v", "<A-Down>", ":MoveBlock(1)<CR>")
noremap("v", "<A-Up>", ":MoveBlock(-1)<CR>")

-- code navigation using LSP server
noremap("n", "<F4>", "<CMD>lua vim.diagnostic.open_float()<CR>")
noremap("n", "<F3>", "<CMD>lua vim.lsp.buf.references()<CR>")
noremap("n", "<F8>", "<CMD>lua vim.diagnostic.goto_next()<CR>")
noremap("n", "<F9>", "<CMD>lua vim.diagnostic.setqflist()<CR>")
noremap("n", "<F12>", "<CMD>lua vim.lsp.buf.definition()<CR>")

-- ctrl+shift+/ to toggle comment
noremap("n", "<C-_>", "<CMD>CommentToggle<CR>")
noremap("i", "<C-_>", "<C-\\><C-N><CMD>CommentToggle<CR>i")
noremap("v", "<C-_>", ":'<,'>CommentToggle<CR>gv")
