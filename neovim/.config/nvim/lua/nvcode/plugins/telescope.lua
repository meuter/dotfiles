local utils = require("nvcode.misc.utils")

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

function M.search_todo(opts)
    opts = opts or {}
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    telescope_builtin.grep_string {
        search="todo(cme)"
    }
end

function M.search_word_under_cursor(opts)
    opts = opts or {}
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    telescope_builtin.grep_string {
        search=utils.get_word_under_cursor()
    }
end

function M.search_selected_text(opts)
    opts = opts or {}
    local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not ok then return end

    telescope_builtin.grep_string {
        search=utils.get_selected_text()
    }
end

function M.search_function()
    local opts = require('telescope.themes').get_dropdown({
        symbols = {
            "function",
            "method",
        },
    })
    require('telescope.builtin').lsp_document_symbols(opts)
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
