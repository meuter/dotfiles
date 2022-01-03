local M = {}

local function configure_telescope(module)
    local ok, telescope = pcall(require, "telescope")
    if not ok then return end

    telescope.setup {
        pickers = {
            find_files = {
                hidden=true,
            },
            buffers = {
                theme="dropdown",
                previewer=false
            }
        }
    }
end

function M.project_files()
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    local git_files_options = {}
    local ok = pcall(telescope_builtin.git_files, git_files_options)
    if not ok then
        local find_files_options = {}
        telescope_builtin.find_files(find_files_options)
    end
end

function M.startup(use)
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = configure_telescope
    }
end

return M