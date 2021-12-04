return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    "nvim-lualine/lualine.nvim",
    requires = {'kyazdani42/nvim-web-devicons', opt=true},
    config = function()
      require("lualine").setup({
          theme='auto',
          options = {section_separators = '', component_separators = ''}
      })
    end
  }

  use {
    "projekt0n/github-nvim-theme",
    after = "lualine.nvim",
    config = function()
      require("github-theme").setup({
        theme_style = "dark"
      })
    end
  }

end)
