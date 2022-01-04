local M = {}

local function configure_nvim_cmp()
    local ok, cmp = pcall(require, "cmp")
    if not ok then return end

    cmp.setup {
        mapping = {
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
        }, {
            { name = 'buffer' },
        })
    }
end

local function configure_lsp()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then return end

    lspconfig.pyright.setup {}
end

function M.startup(use)
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
        },
        config = configure_nvim_cmp()
    }

    use {
        'neovim/nvim-lspconfig',
        config = configure_lsp
    }

end

return M




