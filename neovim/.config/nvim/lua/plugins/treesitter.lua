local load = require("load")

return {
    'nvim-treesitter/nvim-treesitter',
    config = load.and_setup("nvim-treesitter.configs") {
	  ensure_installed = "all",
	  highlight = {
	    enable = true,
	    disable = { },
	  },
    },
    run = ':TSUpdate'
}