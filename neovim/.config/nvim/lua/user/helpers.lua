local M = {}

function M.noremap(mode, key, command)
    local options = {noremap=true, silent=true}
    return vim.api.nvim_set_keymap(mode, key, command, options)
end

function M.project_files()
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    local find_files_options = {}
    local ok = pcall(telescope_builtin.git_files, git_files_options)
    if not ok then
        local git_files_options = {}
        telescope_builtin.find_files(find_files_options)
    end
end

return M