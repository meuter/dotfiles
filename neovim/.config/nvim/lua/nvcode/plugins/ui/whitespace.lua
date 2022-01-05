local M = {}

local function configure_better_whitespace()
    vim.g.better_whitespace_enabled=1
    vim.g.strip_whitespace_on_save=1
    vim.g.strip_whitespace_confirm=0
end

function M.startup(use)
    -- Highlight white space and strip on save
    use {
        "ntpeters/vim-better-whitespace",
        config = configure_better_whitespace()
    }
end

return M
