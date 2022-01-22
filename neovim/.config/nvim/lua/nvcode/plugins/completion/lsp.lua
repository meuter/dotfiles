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
        virtual_text = false,
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

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    lsp_installer.on_server_ready(function(server)
        local opts = {}

        if server.name == "sumneko_lua" then
            local sumneko_opts = require("nvcode.plugins.completion.sumneko_lua")
            opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
        end

        if server.name == "jsonls" then
            local jsonls_opts = require("nvcode.plugins.completion.jsonls")
            opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
        end

        server:setup(opts)
    end)
end

function M.startup(use)
    use {
        "williamboman/nvim-lsp-installer",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "tamago324/nlsp-settings.nvim" },
        },
        config = configure_lsp()
    }
end

return M
