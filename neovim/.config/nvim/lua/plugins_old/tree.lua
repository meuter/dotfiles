local load = require("plugins_old.load")

return {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = load.and_setup("nvim-tree") {}
}
