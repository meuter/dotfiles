local M = {}

local function configure_toggleterm()
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then return end

    toggleterm.setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 3,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    }
end

function M.startup(use)
    use {
        "akinsho/toggleterm.nvim",
        config = configure_toggleterm()
    }
end

return M