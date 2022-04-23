local ui = require("nvcode.plugins.ui")

local treesitter = require("nvcode.plugins.treesitter")
local terminal = require("nvcode.plugins.terminal")
local explorer = require("nvcode.plugins.explorer")
local telescope = require("nvcode.plugins.telescope")
local completion = require("nvcode.plugins.completion")
local git = require("nvcode.plugins.git")
local comment = require("nvcode.plugins.comment")
local debugger = require("nvcode.plugins.debugger")

local function startup(use)
    -- basics
    use "wbthomason/packer.nvim"         -- have packer manage itself
    use "nvim-lua/popup.nvim"            -- an implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"          -- useful lua functions used ny lots of plugins
    use "farmergreg/vim-lastplace"       -- rememnber position in file
    use "valloric/listtoggle"            -- toggle quick and location list
    use "fedepujol/move.nvim"            -- move lines around in V mode
    use "kheaactua/aosp-vim-syntax"      -- syntax highlight for Android.bp, XML manifest, AIDL, HIDL, etc.

    -- groups of plugins centered around certain topics
    ui.startup(use)
    treesitter.startup(use)
    terminal.startup(use)
    explorer.startup(use)
    telescope.startup(use)
    completion.startup(use)
    git.startup(use)
    comment.startup(use)
    debugger.startup(use)
end

return startup
