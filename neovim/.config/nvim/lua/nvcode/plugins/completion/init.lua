local cmp = require("nvcode.plugins.completion.cmp")
local lsp = require("nvcode.plugins.completion.lsp")

local M = {}

function M.startup(use)
    -- Completion engine
    cmp.startup(use)

    -- LSP servers
    lsp.startup(use)
end

return M




