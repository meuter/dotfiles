local ui = require("nvcode.plugins.ui")

local treesitter = require("nvcode.plugins.treesitter")
local terminal = require("nvcode.plugins.terminal")
local explorer = require("nvcode.plugins.explorer")
local telescope = require("nvcode.plugins.telescope")
local completion = require("nvcode.plugins.completion")
local git = require("nvcode.plugins.git")
local comment = require("nvcode.plugins.comment")

local function startup(use)
    -- basics
    use "wbthomason/packer.nvim"         -- have packer manage itself
    use "nvim-lua/popup.nvim"            -- an implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"          -- useful lua functions used ny lots of plugins
    use "farmergreg/vim-lastplace"       -- rememnber position in file
    use "valloric/listtoggle"            -- toggle quick and location list
    use "fedepujol/move.nvim"            -- move lines around in V mode
    use "kheaactua/aosp-vim-syntax"      -- syntax highlight for Android.bp, XML manifest, AIDL, HIDL, etc.

    ui.startup(use)
    treesitter.startup(use)
    terminal.startup(use)
    explorer.startup(use)
    telescope.startup(use)
    completion.startup(use)
    git.startup(use)
    comment.startup(use)

    --   use "lewis6991/impatient.nvim"
    --   use "folke/which-key.nvim"

    --   -- LSP
    --   use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
    --   use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
end

return startup
