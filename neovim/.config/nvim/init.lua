require("defaults")
require("plugins")

local ok, _ = pcall(require, 'github-theme')
if ok then
	require("github-theme").setup()
	vim.cmd("colorscheme github_dark")
end

