local theme = require("nvcode.plugins.theme")
local treesitter = require("nvcode.plugins.treesitter")
local terminal = require("nvcode.plugins.terminal")
local explorer = require("nvcode.plugins.explorer")
local telescope = require("nvcode.plugins.telescope")
local completion = require("nvcode.plugins.completion")
local git = require("nvcode.plugins.git")

function startup(use)
    -- basics
    use "wbthomason/packer.nvim"         -- Have packer manage itself
    use "nvim-lua/popup.nvim"            -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"          -- Useful lua functions used ny lots of plugins
    use "ntpeters/vim-better-whitespace" -- highlight trailing whitespace
    use "farmergreg/vim-lastplace"       -- rememnber position in file

    theme.startup(use)
    treesitter.startup(use)
    terminal.startup(use)
    explorer.startup(use)
    telescope.startup(use)
    completion.startup(use)
    git.startup(use)

    --   use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
    --   use "numToStr/Comment.nvim" -- Easily comment stuff
    --   use "ahmedkhalf/project.nvim"
    --   use "lewis6991/impatient.nvim"
    --   use "lukas-reineke/indent-blankline.nvim"
    --   use "goolord/alpha-nvim"
    --   use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
    --   use "folke/which-key.nvim"

    --   -- LSP
    --   use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    --   use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
    --   use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

    --   use "JoosepAlviste/nvim-ts-context-commentstring"

end

return startup
