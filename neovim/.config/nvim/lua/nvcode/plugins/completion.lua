local M = {}

local function configure_nvim_cmp()
    local ok, cmp = pcall(require, "cmp")
    if not ok then return end

    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if not luasnip_ok then return end

    local kind_icons = {
        Text = "",
        Method = "m",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }

    cmp.setup {

        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body) -- For `luasnip` users.
            end,
        },

        mapping = {
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-y>"] = cmp.config.disable,
            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },


        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }, {
            { name = 'buffer' },
        }),

        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                })[entry.source.name]
                return vim_item
            end,
        },
    }
end

local function configure_lsp()
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
end

local function configure_lsp_installer()
    local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
    if not ok then return end

    lsp_installer.on_server_ready(function(server)
        server:setup {}
    end)
end

function M.startup(use)
    -- Completion engine
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },

            -- some LSP server require a snippet engine
            -- here we use LuaSnip
            { "L3MON4D3/LuaSnip" },
            { "saadparwaiz1/cmp_luasnip" },
        },
        config = configure_nvim_cmp()
    }

    -- Global lsp configuration
    use {
        "neovim/nvim-lspconfig",
        config = configure_lsp()
    }

    -- LSP server installer
    use {
        "williamboman/nvim-lsp-installer",
        config = configure_lsp_installer()
    }


end

return M




