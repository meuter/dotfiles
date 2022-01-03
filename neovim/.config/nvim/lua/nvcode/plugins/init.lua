local packer = require("packer")
local startup = require("nvcode.plugins.startup")

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(startup)