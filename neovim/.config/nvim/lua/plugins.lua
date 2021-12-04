return require('packer').startup(function(use)

    -- Packer
    use 'wbthomason/packer.nvim'

    -- Github theme
    use {
        "projekt0n/github-nvim-theme",
        config = function()  
            local ok, module = pcall(require, "github-theme")
            if ok then 
                module.setup {
                    theme_style = "dark"
                }
            end
        end
    }

    -- Lualine
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            {'kyazdani42/nvim-web-devicons', opt=true},
        },
        config = function()
            local ok, module = pcall(require, "lualine")
            if ok then 
                vim.cmd("set noshowmode laststatus=2")
                module.setup {
                    options = {
                        theme='ayu_dark',
                        section_separators = '', 
                        component_separators = ''
                    }
                }
            end
        end
    }

end)
