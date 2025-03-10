local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup("vlang_ftdetect", { clear = true })
  
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.v",
    callback = function()
      vim.bo.filetype = "vlang"
    end,
    group = augroup
  })
  
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.vv",
    callback = function()
      vim.bo.filetype = "vlang"
    end,
    group = augroup
  })
  
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.vsh",
    callback = function()
      vim.bo.filetype = "vlang"
    end,
    group = augroup
  })
end

return M
