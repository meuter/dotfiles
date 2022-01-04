local theme = require("nvcode.plugins.theme")
local treesitter = require("nvcode.plugins.treesitter")
local terminal = require("nvcode.plugins.terminal")
local explorer = require("nvcode.plugins.explorer")
local telescope = require("nvcode.plugins.telescope")
local completion = require("nvcode.plugins.completion")

function startup(use)
    -- My plugins here
    use "wbthomason/packer.nvim"    -- Have packer manage itself
    use "nvim-lua/popup.nvim"       -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"     -- Useful lua functions used ny lots of plugins

    theme.startup(use)
    treesitter.startup(use)
    terminal.startup(use)
    explorer.startup(use)
    telescope.startup(use)
    completion.startup(use)

    --   use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
    --   use "numToStr/Comment.nvim" -- Easily comment stuff
    --   use "ahmedkhalf/project.nvim"
    --   use "lewis6991/impatient.nvim"
    --   use "lukas-reineke/indent-blankline.nvim"
    --   use "goolord/alpha-nvim"
    --   use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
    --   use "folke/which-key.nvim"

    --   -- cmp plugins
    --   use "hrsh7th/nvim-cmp" -- The completion plugin
    --   use "hrsh7th/cmp-buffer" -- buffer completions
    --   use "hrsh7th/cmp-path" -- path completions
    --   use "hrsh7th/cmp-cmdline" -- cmdline completions
    --   use "saadparwaiz1/cmp_luasnip" -- snippet completions
    --   use "hrsh7th/cmp-nvim-lsp"

    --   -- snippets
    --   use "L3MON4D3/LuaSnip" --snippet engine
    --   use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    --   -- LSP
    --   use "neovim/nvim-lspconfig" -- enable LSP
    --   use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    --   use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
    --   use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

    --   -- Treesitter
    --   use {
    --     "nvim-treesitter/nvim-treesitter",
    --     run = ":TSUpdate",
    --   }
    --   use "JoosepAlviste/nvim-ts-context-commentstring"

    --   -- Git
    --   use "lewis6991/gitsigns.nvim"
end

return startup
