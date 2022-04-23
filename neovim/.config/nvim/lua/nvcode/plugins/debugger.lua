local M = {}

local function configure_nvim_dap()

    local ok, dap = pcall(require, "dap")
    if not ok then return end

    -- configuration for LLDB
    lldb_adapter = {
        type = 'executable',
        command = '/usr/sbin/lldb-vscode', -- TODO(cme): install lldb in .local from install.sh
        name = "lldb"
    }
    lldb_configuration = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            -- TODO(cme): use telescope to pick executable fron a list coming from LSP
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
            args = {},
            runInTerminal = false,
            postRunCommands = { 'process handle -p true -s false -n false SIGWINCH' }
        },
    }

    -- configurations for C/C++/Rust
    dap.adapters.lldb = lldb_adapter
    dap.configurations.cpp = lldb_configuration
    dap.configurations.c = lldb_configuration
    dap.configurations.rust = lldb_configuration

    -- gutter symbols
    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '🟡', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '⏩', texthl = '', linehl = '', numhl = '' })
end

local function configure_nvim_dap_ui()

    local dapui_ok, dapui = pcall(require, "dapui")
    if not dapui_ok then return end

    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then return end

    dapui.setup({
        icons = { expanded = "", collapsed = "" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        sidebar = {
            -- You can change the order of elements in the sidebar
            elements = {
                -- Provide as ID strings or tables with "id" and "size" keys
                {
                    id = "scopes",
                    size = 0.25, -- Can be float or integer > 1
                },
                { id = "watches", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left", "right", "top", "bottom"
        },
        tray = {
            -- elements = { "repl" },
            elements = {},
            size = 10,
            position = "bottom", -- Can be "left", "right", "top", "bottom"
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = "single", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
        render = {
            max_type_length = nil, -- Can be integer or nil.
        }
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
        print("open")
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        print("close")
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        print("close")
        dapui.close()
    end

end

function M.startup(use)
    use {
        'mfussenegger/nvim-dap',
        config = configure_nvim_dap
    }
    use {
        'rcarriga/nvim-dap-ui',
        config = configure_nvim_dap_ui
    }
end

return M
