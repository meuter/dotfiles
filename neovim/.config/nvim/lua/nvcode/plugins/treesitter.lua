local M = {}

local function configure_treesitter()
    local ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    treesitter.setup {
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = { "" }, -- List of parsers to ignore installing
        autopairs = {
            enable = true,
        },
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = { "" }, -- list of language that will be disabled
            additional_vim_regex_highlighting = true,
        },
        indent = {
            enable = true,
            disable = { "yaml" }
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        }
    }
end

function M.startup(use)
    -- Configure tree sitter
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = '668de0951a36ef17016074f1120b6aacbe6c4515',
        config = configure_treesitter(),
        run = ':TSUpdate'
    }

    -- Provide better context to Comments.nvim
    use {
        'JoosepAlviste/nvim-ts-context-commentstring'
    }
end

return M
