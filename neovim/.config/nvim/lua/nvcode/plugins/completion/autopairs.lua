local M = {}

local function configure_nvim_autopairs()
    local ok, autopairs = pcall(require, "nvim-autopairs")
    if not ok then return end

    autopairs.setup({
        disable_filetype = { "TelescopePrompt" , "vim" },
    })
end

function M.startup(use)
    -- Autopairs, integrates with both cmp and treesitter
    use {
        "windwp/nvim-autopairs",
        config = configure_nvim_autopairs()
    }
end


return M
