local M = {}

function M.error(message)
  vim.notify(
    '[fold-ribbon]: ' .. message,
    vim.log.levels.ERROR
  )
end

function M.warn(message)
  vim.notify(
    '[fold-ribbon]: ' .. message,
    vim.log.levels.WARN
  )
end

return M
