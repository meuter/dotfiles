local load = require("plugins_old.load")

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
                { 'branch', color = { fg="LightSkyBlue1", bg="gray16"} },
                { cwd, color = { fg="LightYellow"} },
                'diff',
                'diagnostics'
            },
            lualine_c = {
                { 'filename', path=1 }
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
