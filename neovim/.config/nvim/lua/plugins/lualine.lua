local load = require("load")

function configure(module)
    module.setup {
        options = {
            theme='ayu_dark',
            section_separators = '',
            component_separators = ''
        },
    }
    vim.cmd("set noshowmode laststatus=2")
end

return {
    "nvim-lualine/lualine.nvim",
    requires = {
        {'kyazdani42/nvim-web-devicons'},
    },
    config = load.and_configure("lualine", configure)
}