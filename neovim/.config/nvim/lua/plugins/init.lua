require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use(require("plugins/theme"))
    use(require("plugins/lualine"))
    use(require("plugins/treesitter"))
    use(require("plugins/telescope"))
    use(require("plugins/lspconfig"))
    use(require("plugins/cmp"))
    use(require("plugins/tree"))
end)