function setup(module_name)
    function setup_result(opts)
        local ok, module = pcall(require, module_name)
        if ok then
            module.setup(opts)
        end
        if opts["configure"] then
            opts.configure()
        end
    end
    return setup_result
end


return require('packer').startup(function(use)

    -- Packer
    use 'wbthomason/packer.nvim'

    -- Github theme
    use {
        "projekt0n/github-nvim-theme",
        config = setup("github-theme") {
            theme_style = "dark"
        }
    }

    -- Lualine
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            {'kyazdani42/nvim-web-devicons', opt=true},
        },
        config = setup("lualine") {
            options = {
                theme='ayu_dark',
                section_separators = '',
                component_separators = ''
            },
            configure = function()
                vim.cmd("set noshowmode laststatus=2")
            end
        }
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'}
        },
        config = setup("telescope") {
            pickers = {
                find_files = {
                    hidden=true,
                }
            },
            configure = function()
                vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope git_files<cr>", { silent=true})
            end
        }
    }

end)
