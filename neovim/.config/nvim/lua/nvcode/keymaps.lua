local function detect_key(letter)
    vim.api.nvim_set_keymap("n", "<A-" .. letter .. ">", "<CMD>lua print('Alt+" .. letter .. " pressed')<CR>", {})
    vim.api.nvim_set_keymap("n", "<S-" .. letter .. ">", "<CMD>lua print('Shift+" .. letter .. " pressed')<CR>", {})
    vim.api.nvim_set_keymap("n", "<C-" .. letter .. ">", "<CMD>lua print('Ctrl+" .. letter .. " pressed')<CR>", {})
    vim.api.nvim_set_keymap("n", "<C-S-" .. letter .. ">", "<CMD>lua print('Ctrl+Shift+" .. letter .. " pressed')<CR>", {}) -- DOES NOT WORK
    vim.api.nvim_set_keymap("n", "<C-" .. letter .. ">", "<CMD>lua print('Ctrl+" .. letter .. " pressed')<CR>", {})
    vim.api.nvim_set_keymap("n", "<C-A-" .. letter .. ">", "<CMD>lua print('Ctrl+" .. letter .. "lt+a pressed')<CR>", {}) -- DOES NOT WORK
end

-- TODO(cme): switch to nvim 0.7 to have the nice API to set key map
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
remap_all_modes("<C-p>", "<CMD>ProjectFiles<CR>")

-- ctrl+t to select open a buffer
remap_all_modes("<C-t>", "<CMD>Telescope buffers<CR>")

-- ctrl+k for command pallette
remap_all_modes("<C-k>", "<CMD>Telescope commands<CR>")

-- ctrl+n to navigate to another directory in ~/
remap_all_modes("<C-n>", "<CMD>Navigate<CR>")

-- ctrl+y same as ctrl+ù for live grep search
remap_all_modes("<C-Y>", "<CMD>Telescope live_grep<CR>")

-- ctrl+] to search word under the cursor
noremap("n", "<C-]>", "<CMD>SearchWordUnderCursor<CR>")
noremap("v", "<C-]>", "<esc><CMD>SearchSelectedText<CR>")

-- ctrl+g to open git fugitive
remap_all_modes("<C-g>", "<CMD>Git<CR>")
remap_for_filetype("fugitive", "n", "<C-G>", "<CMD>q<CR>")
remap_for_filetype("fugitive", "n", "<esc><esc>", "<CMD>q<CR>")
remap_for_filetype("fugitive", "n", "cc", "<CMD>q<bar>Git commit --quiet<CR>")

-- ctrl-[or] to navigate buffer
remap_all_modes("<C-PageUp>", "<CMD>BufferLineCyclePrev<CR>")
remap_all_modes("<C-PageDown>", "<CMD>BufferLineCycleNext<CR>")

-- ctrl+b to toggle file explorer
remap_all_modes("<C-b>", "<CMD>NvimTreeToggle<CR>")
remap_for_filetype("NvimTree", "n", "<F5>", "<CMD>NvimTreeRefresh<CR>")

-- ctrl+j to toggle terminal
remap_all_modes("<C-j>", "<CMD>ToggleTerm<CR>")
noremap("t", "<esc>", "<CMD>ToggleTerm<CR>")
noremap("t", "<C-j>", "<CMD>ToggleTerm<CR>")

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
noremap("i", "<A-Down>", "<C-\\><C-N>:MoveLine(1)<CR>")
noremap("i", "<A-Up>", "<C-\\><C-N>:MoveLine(1)<CR>")

-- code navigation using LSP server
remap_all_modes("<F1>", "<CMD>lua vim.lsp.buf.hover()<CR>")
remap_all_modes("<F2>", "<CMD>lua vim.lsp.buf.rename()<CR>")
remap_all_modes("<F3>", "<CMD>lua vim.lsp.buf.references()<CR>")
remap_all_modes("<F4>", "<CMD>lua vim.diagnostic.open_float()<CR>")
-- <F5> is free
-- <F7> is free
-- <F7> is free
remap_all_modes("<F8>", "<CMD>lua vim.diagnostic.goto_next()<CR>")
remap_all_modes("<F9>", "<CMD>Telescope diagnostics<CR>")
-- <F11> is taken by Windows Terminal to toggle full-screen
remap_all_modes("<F12>", "<CMD>lua vim.lsp.buf.definition()<CR>")

-- ctrl+shift+/ to toggle comment
noremap("n", "<C-_>", "<CMD>CommentToggle<CR>j")
noremap("i", "<C-_>", "<C-\\><C-N><CMD>CommentToggle<CR>ji")
noremap("v", "<C-_>", ":'<,'>CommentToggle<CR>gv<esc>j")

-- ctrl+d to toggle git diff view
noremap("n", "<C-d>", "<CMD>DiffviewOpen<CR>")
remap_for_filetype("DiffviewFiles", "n", "<C-d>", "<CMD>DiffviewClose<CR>")

-- ctrl+a to toggle copy friendly mode
noremap("n", "<C-a>", "<CMD>ToggleMouseCopy<CR>")

-- ctrl+o to search function
remap_all_modes("<C-o>", "<CMD>SearchFunction<CR>")
