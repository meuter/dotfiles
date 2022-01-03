local load = require("load")

return {
    "itmecho/neoterm.nvim",
    config=load.and_setup("neoterm") {
    	clear_on_run = true, -- run clear command before user specified commands
    	mode = 'horizontal',   -- vertical/horizontal/fullscreen
    	noinsert = false     -- disable entering insert mode when opening the neoterm window
    }
}
