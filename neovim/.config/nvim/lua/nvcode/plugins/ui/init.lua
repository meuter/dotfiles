local colorscheme = require("nvcode.plugins.ui.colorscheme")
local lualine = require("nvcode.plugins.ui.lualine")
local bufferline = require("nvcode.plugins.ui.bufferline")
local indentline = require("nvcode.plugins.ui.indentline")
local whitespace = require("nvcode.plugins.ui.whitespace")

local M = {}

function M.startup(use)
    colorscheme.startup(use)
    lualine.startup(use)
    bufferline.startup(use)
    indentline.startup(use)
    whitespace.startup(use)
end

return M
