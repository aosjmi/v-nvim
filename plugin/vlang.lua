

if vim.g.loaded_vlang_plugin then
  return
end
vim.g.loaded_vlang_plugin = true
require('vlang').setup()
