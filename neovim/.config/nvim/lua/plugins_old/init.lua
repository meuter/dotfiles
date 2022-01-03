require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use(require("plugins_old/theme"))
    use(require("plugins_old/lualine"))
    use(require("plugins_old/treesitter"))
    use(require("plugins_old/telescope"))
    use(require("plugins_old/lspconfig"))
    use(require("plugins_old/cmp"))
    use(require("plugins_old/tree"))
    use(require("plugins_old/neoterm"))
end)
