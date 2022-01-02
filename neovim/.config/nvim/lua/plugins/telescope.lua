local load = require("load")

function configure(module)
    module.setup {
        pickers = {
            find_files = {
                hidden=true,
            }
        },
    }
end


return {
    'nvim-telescope/telescope.nvim',
    requires = {
        {'nvim-lua/plenary.nvim'}
    },
    config = load.and_configure("telescope",configure)
}