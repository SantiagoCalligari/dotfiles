-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.mapping")
-- Set the *.blade.php file to be filetype of blade
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.blade.php",
  command = "set ft=blade",
})
