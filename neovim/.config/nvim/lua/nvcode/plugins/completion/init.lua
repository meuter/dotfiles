local cmp = require("nvcode.plugins.completion.cmp")
local lsp = require("nvcode.plugins.completion.lsp")
local autopairs = require("nvcode.plugins.completion.autopairs")
local M = {}

function M.startup(use)
    -- Completion engine
    cmp.startup(use)

    -- LSP servers
    lsp.startup(use)

    -- Autopairs
    autopairs.startup(use)
end

return M




