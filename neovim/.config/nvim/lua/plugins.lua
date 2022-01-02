local load = require("load")

return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'

    use {
        "projekt0n/github-nvim-theme",
        config = load.and_setup("github-theme") {
            theme_style = "dark"
        }
    }

    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            {'kyazdani42/nvim-web-devicons', opt=true},
        },
        config = load.and_configure("lualine", function(module)
            module.setup {
                options = {
                    theme='ayu_dark',
                    section_separators = '',
                    component_separators = ''
                },
            }
            vim.cmd("set noshowmode laststatus=2")
        end)

    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'}
        },
        config = load.and_configure("telescope", function(module)
            module.setup {
                pickers = {
                    find_files = {
                        hidden=true,
                    }
                },
            }
            vim.api.nvim_set_keymap("n", "<C-p>", "<CMD>lua require('project-files').project_files()<CR>", {noremap = true, silent = true})
        end)
    }

    use {
        'neovim/nvim-lspconfig',
        config = load.and_configure("lspconfig", function(module)
            module.pyright.setup {}
        end)
    }

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
        },
        config = load.and_configure("cmp", function(cmp)
            cmp.setup {
                mapping = {
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-y>'] = cmp.config.disable,
                    ['<C-e>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            }
        end)
    }

end)
