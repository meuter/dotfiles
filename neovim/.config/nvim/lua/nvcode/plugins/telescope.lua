local M = {}

local function configure_telescope()
    local ok, telescope = pcall(require, "telescope")
    if not ok then return end

    telescope.setup {
        pickers = {
            buffers = {
                theme="dropdown",
                previewer=false
            }
        },
        defaults = {
            prompt_prefix = "🔎 ",
            color_devicons = true,
            selection_caret = "❯ ",
            preview = {
                treesitter = false,
            },
        },
    }
    telescope.load_extension("fzf")
end

function M.project_files(opts)
    opts = opts or {}
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    local git_files_ok = pcall(telescope_builtin.git_files, opts)
    if not git_files_ok then
        telescope_builtin.find_files(opts)
    end
end


function M.live_grep_selected_string(opts)
    opts = opts or {}
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    -- TODO(cme): get the selected in VISUAL mode and grep for that
--  --            verbatim (using quotes or something, escape spaces, etc...)
    telescope_builtin.grep_string()
end

function M.navigate(opts)
    local actions = require('telescope.actions')
    local config  = require('telescope.config').values
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions_state = require('telescope.actions.state')
    local from_entry = require('telescope.from_entry')

    local cmd = { "bfs", os.getenv("HOME"), "-type", "d",
        "-exclude", "-name", ".npm",
        "-exclude", "-name", ".gradle",
        "-exclude", "-name", ".vscode-server",
        "-exclude", "-name", ".cache",
        "-exclude", "-name", ".git",
        "-exclude", "-name", ".repo",
        "-exclude", "-name", "node_modules",
    }

    opts = opts or {}

    pickers.new(opts, {
        prompt_title = "Navigate",
        finder = finders.new_oneshot_job(cmd),
        sorter = config.file_sorter(opts),
        previewer = config.file_previewer(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local entry = actions_state.get_selected_entry()
                local dir = from_entry.path(entry)
                vim.cmd('cd '..dir)
            end)
            return true
        end,
    }):find()
end

function M.search_and_replace()
    local text_to_replace = vim.fn.input("Replace> ")
    if text_to_replace == "" then return end

    vim.cmd("vimgrep /" .. text_to_replace .. "/gj **/*")
    local replacement = vim.fn.input("With> ");
    if replacement == "" then return end

    vim.cmd("redraw")
    vim.cmd("cfdo %s/" .. text_to_replace .. "/" .. replacement .. "/gc")
end

function M.search_todo()
    opts = opts or {}
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    telescope_builtin.grep_string {
        search="TODO(cme)"
    }
end

function M.startup(use)
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        },
        config = configure_telescope
    }
end

return M
