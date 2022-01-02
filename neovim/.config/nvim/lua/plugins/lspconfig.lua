local load = require("load")

return {
    'neovim/nvim-lspconfig',
    config = load.and_configure("lspconfig", function(module)
        module.pyright.setup {}
    end)
}