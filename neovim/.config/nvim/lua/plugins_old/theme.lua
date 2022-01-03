local load = require("load")

return {
    "projekt0n/github-nvim-theme",
    config = load.and_setup("github-theme") {
        theme_style = "dark"
    }
}