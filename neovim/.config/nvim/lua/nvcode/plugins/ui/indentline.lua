local M = {}

local function configure_indentline()
    local ok, indent_blankline = pcall(require, "indent_blankline")
    if not ok then return end

    vim.g.indent_blankline_char = "▏"
    vim.g.indent_blankline_show_trailing_blankline_indent = false

    vim.opt.list = true
    vim.opt.listchars:append("space:⋅")
    vim.opt.listchars:append("eol:")
    vim.opt.listchars:append("tab: ")

    indent_blankline.setup {
        enabled = true,
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        blankline_char = "▏",
        use_treesitter = true,
        buftype_exclude = {
            "terminal",
            "nofile"
        },
        filetype_exclude = {
            "help",
            "startify",
            "dashboard",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
        },
        show_end_of_line = true,
        space_char_blankline = " ",
    }
end

local ready_for_mouse_copy = true

function M.toggle_mouse_copy()

    pcall(vim.cmd, "IndentBlanklineToggle")
    pcall(vim.cmd, "Gitsigns toggle_signs")

    if ready_for_mouse_copy then
        vim.opt.mouse = "i"
        vim.opt.number = false
        vim.opt.list = false
        vim.opt.signcolumn = "no"
        ready_for_mouse_copy = false
    else
        vim.opt.mouse = "a"
        vim.opt.number = true
        vim.opt.list = true
        vim.opt.signcolumn = "yes"
        ready_for_mouse_copy = true
    end
end

function M.startup(use)
    -- Indent line and display hidden characters (spaces/tabs)
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = configure_indentline()
    }

end

return M
