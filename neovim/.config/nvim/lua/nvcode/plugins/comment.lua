local M = {}

local function configure_comments()
    local ok, comment = pcall(require, "nvim_comment")
    if not ok then return end

    comment.setup {
        hook = function()
            if vim.api.nvim_buf_get_option(0, "filetype") == "vue" then
                require("ts_context_commentstring.internal").update_commentstring()
            end
        end
    }
end



function M.startup(use)
    -- Allow to toggle comments
    use {
        "terrortylor/nvim-comment",
        config = configure_comments()
    }
end

return M
