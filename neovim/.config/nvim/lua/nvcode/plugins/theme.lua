local M = {}

local function configure_github_theme()
    local ok, github_theme = pcall(require, "github-theme")
    if not ok then return end

    github_theme.setup {
        theme_style="dark"
    }
end

local function configure_lualine()
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    local cwd = {
        function()
           local home = os.getenv("HOME")
           local icon = "📁 "
           return icon .. vim.fn.getcwd():gsub(home, "~")
       end,
       color = { fg="LightYellow"}
    }

    local branch = {
        "branch",
        icons_enabled = true,
        icon = "",
    }

    local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = { error = " ", warn = " " },
        colored = false,
        update_in_insert = false,
        always_visible = true,
    }

    local spaces = function()
        return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    end

    local location = {
        "location",
        padding = 0,
    }

    lualine.setup {
        options = {
            icons_enabled = true,
            theme = "ayu_dark",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "NvimTree", "Outline" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = { branch , diagnostics },
            lualine_c = { cwd },
            lualine_x = { 'filetype' },
            lualine_y = { location, spaces, 'encoding', 'fileformat' },
            lualine_z = { }
        },
    }
end

local function configure_bufferline()
    local ok, bufferline = pcall(require, "bufferline")
    if not ok then return end

    bufferline.setup {
        options = {
            numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
            close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
            right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
            left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
            middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
            indicator_icon = "▎",
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 30,
            max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
            tab_size = 21,
            diagnostics = false, -- | "nvim_lsp" | "coc",
            diagnostics_update_in_insert = false,
            offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
            enforce_regular_tabs = true,
            always_show_bufferline = true,
        },
        highlights = {
            fill = {
                guifg = { attribute = "fg", highlight = "#ff0000" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            background = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            buffer_visible = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button_visible = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            tab_selected = {
                guifg = { attribute = "fg", highlight = "Normal" },
                guibg = { attribute = "bg", highlight = "Normal" },
            },
            tab = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            tab_close = {
                guifg = { attribute = "fg", highlight = "TabLineSel" },
                guibg = { attribute = "bg", highlight = "Normal" },
            },
            duplicate_selected = {
                guifg = { attribute = "fg", highlight = "TabLineSel" },
                guibg = { attribute = "bg", highlight = "TabLineSel" },
                gui = "italic",
            },
            duplicate_visible = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
                gui = "italic",
            },
            duplicate = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
                gui = "italic",
            },
            modified = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            modified_selected = {
                guifg = { attribute = "fg", highlight = "Normal" },
                guibg = { attribute = "bg", highlight = "Normal" },
            },
            modified_visible = {
                guifg = { attribute = "fg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            separator = {
                guifg = { attribute = "bg", highlight = "TabLine" },
                guibg = { attribute = "bg", highlight = "TabLine" },
            },
            separator_selected = {
                guifg = { attribute = "bg", highlight = "Normal" },
                guibg = { attribute = "bg", highlight = "Normal" },
            },
            indicator_selected = {
                guifg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
                guibg = { attribute = "bg", highlight = "Normal" },
            },
        }
    }
end

function M.startup(use)
    -- Nice icons for NF font
    use { use "kyazdani42/nvim-web-devicons" }

    -- Github color scheme
    use {
        "projekt0n/github-nvim-theme",
        config = configure_github_theme()
    }

    -- Lualine
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            { "kyazdani42/nvim-web-devicons" }
        },
        config = configure_lualine()
    }

    -- Bufferline
    use {
        "akinsho/bufferline.nvim",
        requires = {
            { "kyazdani42/nvim-web-devicons"} ,
            { "moll/vim-bbye" }
        },
        config = configure_bufferline()
    }
end

return M
