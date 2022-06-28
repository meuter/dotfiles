-- Tab/Shift+tab to indent/dedent
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("n", "<Tab>", "v><C-\\><C-N>")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<S-Tab>", "v<<C-\\><C-N>")
vim.keymap.set("i", "<S-Tab>", "<C-\\><C-N>v<<C-\\><C-N>^i")

-- Ctrl+Left/Right use word boundary
vim.keymap.set("n", "<C-Left>", "b")
vim.keymap.set("n", "<C-Right>", "w")

-- Alt+Left/Right to navigate jumplist
vim.keymap.set("n", "<A-Left>", "<C-O>")
vim.keymap.set("n", "<A-Right>", "<C-I>")

-- Ctrl+w in insert mode automatically escpaces
vim.keymap.set("i", "<C-w>", "<C-\\><C-N><C-w>")

-- ; as an alias to :
vim.keymap.set("n", ";", ":")

-- '-' and '=' to bavigate buffer
vim.keymap.set("n", "-", "<CMD>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "=", "<CMD>BufferLineCycleNext<CR>")

-- '_' and '+' to navigate tabs
vim.keymap.set("n", "_", "<C-PageDown>")
vim.keymap.set("n", "+", "<C-PageUp>")


