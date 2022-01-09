local M = {}

local function configure_github_theme()
    local ok, github_theme = pcall(require, "github-theme")
    if not ok then return end

    github_theme.setup {
        theme_style="dark",
        function_style = "NONE",
        comment_style = "NONE",
        keyword_style = "NONE",
    }
end

function M.startup(use)
    -- Github color scheme
    use {
        "projekt0n/github-nvim-theme",
        config = configure_github_theme()
    }
end

return M
