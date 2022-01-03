local load = require("plugins_old.load")

function configure(module)
    module.setup {
        mapping = {
            ['<C-Space>'] = module.mapping(module.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = module.config.disable,
            ['<C-e>'] = module.mapping({
                i = module.mapping.abort(),
                c = module.mapping.close(),
            }),
            ['<CR>'] = module.mapping.confirm({ select = true }),
        },
        sources = module.config.sources({
            { name = 'nvim_lsp' },
        }, {
            { name = 'buffer' },
        })
    }
end

return {
    'hrsh7th/nvim-cmp',
    requires = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
    },
    config = load.and_configure("cmp", configure)
}
