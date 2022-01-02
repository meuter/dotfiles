local load = require("load")

function cwd()
    local home = os.getenv("HOME")
    return "📁" .. vim.fn.getcwd():gsub(home, "~")
end

function configure(module)
    module.setup {
        options = {
            theme='ayu_dark',
            section_separators = '',
            component_separators = ''
        },
        sections = {
            lualine_b = {
                { cwd, color = { fg="LightYellow"} },
                { 'branch', color = { fg="LightSkyBlue1", bg="gray16"} }, 
                'diff', 
                'diagnostics'
            },
        }
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
