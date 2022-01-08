local M = {}

local function configure_lsp()
    local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
    if not ok then return end

    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    lsp_installer.on_server_ready(function(server)
        server:setup {}
    end)
end

function M.startup(use)
    use {
        "williamboman/nvim-lsp-installer",
        requires = {
            { "neovim/nvim-lspconfig" },
        },
        config = configure_lsp()
    }
end

return M
