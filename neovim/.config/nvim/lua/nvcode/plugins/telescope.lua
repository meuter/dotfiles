local M = {}

local function configure_telescope()
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
        },
        defaults = {
            preview = {
                treesitter = false,
            },
       },
    }
end

function M.project_files()
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    local git_files_options = {}
    local git_files_ok = pcall(telescope_builtin.git_files, git_files_options)
    if not git_files_ok then
        local find_files_options = {}
        telescope_builtin.find_files(find_files_options)
    end
end


local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local utils = require('telescope.utils')
local actions_set = require('telescope.actions.set')
local actions_state = require('telescope.actions.state')
local from_entry = require('telescope.from_entry')

function M.navigate()
    local name="Navigate"
    -- TODO(cme): get this from FZF env variable
    -- FZ_ALT_C_COMMAND="bfs ~/ -type d -exclude -name '.local' -exclude -name '.npm' -exclude -name '.cache' -exclude -name '.git'"F
    local cmd = { "bfs", "/home/cme/", "-type", "d",
        "-exclude", "-name", ".local",
        "-exclude", "-name", ".npm",
        "-exclude", "-name", ".cache",
        "-exclude", "-name", ".git"
    }

    pickers.new({}, {
        prompt_title = name,
        finder = finders.new_table{ results = utils.get_os_command_output(cmd) },
        previewer = false,
        sorter = sorters.get_fzy_sorter(),
        attach_mappings = function(prompt_bufnr)
            actions_set.select:replace(function(_, _)
                local entry = actions_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local dir = from_entry.path(entry)
                vim.cmd('cd '..dir)
            end)
            return true
        end,
    }):find()
end

function M.startup(use)
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = configure_telescope
    }
end

return M
