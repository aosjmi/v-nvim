local M = {}

function M.setup()
  if vim.b.did_indent then
    return
  end
  
  vim.b.did_indent = 1

  vim.bo.lisp = false
  vim.bo.autoindent = true
  vim.bo.indentexpr = "v:lua.require('vlang.indent').indent_line(v:lnum)"
  vim.bo.indentkeys = vim.bo.indentkeys .. "<:>,0=},0=)"
  vim.bo.expandtab = false
end

function M.indent_line(lnum)
  local prevlnum = vim.fn.prevnonblank(lnum - 1)
  if prevlnum == 0 then
    return 0
  end

  local prevl = vim.fn.getline(prevlnum):gsub("//.*$", "")
  local thisl = vim.fn.getline(lnum):gsub("//.*$", "")
  local previ = vim.fn.indent(prevlnum)

  local ind = previ

  if prevl:match("[({]%s*$") then
    ind = ind + vim.fn.shiftwidth()
  end
  
  if prevl:match("^%s*case .*:$") or prevl:match("^%s*default:$") then
    ind = ind + vim.fn.shiftwidth()
  end

  if thisl:match("^%s*[)}]") then
    ind = ind - vim.fn.shiftwidth()
  end

  if thisl:match("^%s*case .*:$") or thisl:match("^%s*default:$") then
    ind = ind - vim.fn.shiftwidth()
  end

  return ind
end

M.setup()

return M
