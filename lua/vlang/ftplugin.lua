local M = {}

function M.setup()
  if vim.b.did_ftplugin then
    return
  end
  
  vim.b.did_ftplugin = 1

  vim.bo.commentstring = "// %s"
  vim.bo.makeprg = "v %"

  if vim.b.undo_ftplugin then
    vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "|setlocal commentstring< makeprg<"
  else
    vim.b.undo_ftplugin = "setlocal commentstring< makeprg<"
  end
  
  local function v_format_file()
    if (vim.g.v_autofmt_bufwritepre and vim.g.v_autofmt_bufwritepre ~= 0) or 
       (vim.b.v_autofmt_bufwritepre and vim.b.v_autofmt_bufwritepre ~= 0) then
      
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local content = table.concat(lines, "\n")
      
      local substitution = vim.fn.system("v fmt -", content)
      
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_err_writeln("vfmtによるバッファフォーマット中にエラーが発生しました:")
        vim.api.nvim_err_writeln(string.format("ERROR(%d): %s", vim.v.shell_error, substitution))
      else
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local lnum, colnum = cursor_pos[1], cursor_pos[2]
        
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(substitution, "\n"))
        vim.api.nvim_win_set_cursor(0, {lnum, colnum})
      end
    end
  end
  
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.v",
    callback = v_format_file,
    group = vim.api.nvim_create_augroup("v_fmt", { clear = true })
  })
end

M.setup()

return M
