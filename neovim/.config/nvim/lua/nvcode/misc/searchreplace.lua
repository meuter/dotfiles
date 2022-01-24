local M = {}

function M.search_and_replace()
    local text_to_replace = vim.fn.input("Replace: ")
    if text_to_replace == "" then return end

    vim.cmd("vimgrep /" .. text_to_replace .. "/gj **/*")
    local replacement = vim.fn.input("Replace '" .. text_to_replace .. "' with: ");
    if replacement == "" then return end

    vim.cmd("redraw")
    vim.cmd("cfdo %s/" .. text_to_replace .. "/" .. replacement .. "/gc")
    vim.cmd("noh")
end

return M
