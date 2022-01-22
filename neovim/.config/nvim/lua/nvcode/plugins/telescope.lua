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

function M.convert_hexstring_to_c_array()
    -- grab current line
    local line = vim.api.nvim_get_current_line()

    -- strip  spaces
    line = line:gsub("%s+$",""):gsub("^%s+","")

    -- check if all remaining characters are hexadeciml digits
    local non_hex_digits = line:gsub("%x+","")
    if #non_hex_digits ~= 0 then
        print("ERROR: Lines contains non hexadecimal digits '" .. non_hex_digits .. "'")
        return
    end

    -- check if even number of digits
    if #line % 2 ~= 0 then
        print("ERROR: Line does not contain an even number of digits '" .. #line .. "'")
        return
    end

    -- replace pairs of digits 'DD' by '0xDD, ' grouped by 16 bytes
    local bytes = {}
    local byte_count = 0
    local lines_to_insert = {}
    for i = 1, #line, 2 do
        local byte = line:sub(i,i+1)
        byte_count = byte_count+1
        table.insert(bytes, "0x" .. byte)
        if byte_count % 16 == 0 then
            local new_line =table.concat(bytes, ", ")
            if i+1 ~= #line then
                new_line = new_line .. ","
            end
            table.insert(lines_to_insert, new_line)
            bytes = {}
        end
    end

    if #bytes > 0 then
        table.insert(lines_to_insert, table.concat(bytes, ", "))
    end

    -- perform the edit
    local current_position = vim.api.nvim_win_get_cursor(0)
    local current_line_index = current_position[1] -- lua table are 1-indexed!
    vim.api.nvim_buf_set_lines(0, current_line_index-1, current_line_index, true, lines_to_insert)
end

function M.search_todo(opts)
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
