local M = {}

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
            lualine_y = { location, spaces, 'encoding', },
            lualine_z = { 'fileformat' }
        },
    }
end

function M.startup(use)
    -- Lualine
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            { "kyazdani42/nvim-web-devicons" }
        },
        config = configure_lualine()
    }
end

return M

