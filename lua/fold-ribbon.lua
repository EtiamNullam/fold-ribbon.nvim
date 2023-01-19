local M =  {}

function M.setup()
  if vim.fn.has('nvim-0.9') == 0 then
    vim.notify(
      '[fold-ribbon]: Configuration of "statuscolumn" requires latest version of neovim nightly (>= 0.9)',
      vim.log.levels.WARN
    )

    return
  end

  vim.o.foldcolumn = '0'

  vim.o.statuscolumn = '%s'
    .. '%#FoldColumnDynamic#'
    .. "%{v:lua.require'fold-ribbon'.apply_highlight_to_dynamic_foldcolumn(v:lnum)}"
    .. (vim.o.number and '%## %=%l ' or '')
end

local fg = {
  bright = '#ffffff',
  dark = '#000000',
}

local highlight_levels = {
  {
    link = 'FoldLevel',
  },
  {
    fg = fg.dark,
    bg = '#eeeeee',
  },
  {
    fg = fg.dark,
    bg = '#dddddd',
  },
  {
    fg = fg.dark,
    bg = '#cccccc',
  },
  {
    fg = fg.dark,
    bg = '#bbbbbb',
  },
  {
    fg = fg.dark,
    bg = '#aaaaaa',
  },
  {
    fg = fg.bright,
    bg = '#999999',
  },
  {
    fg = fg.bright,
    bg = '#888888',
  },
  {
    fg = fg.bright,
    bg = '#777777',
  },
  {
    fg = fg.bright,
    bg = '#666666',
  },
  {
    fg = fg.bright,
    bg = '#555555',
  },
  {
    fg = fg.bright,
    bg = '#444444',
  },
  {
    fg = fg.bright,
    bg = '#333333',
  },
  {
    fg = fg.bright,
    bg = '#222222',
  },
  {
    fg = fg.bright,
    bg = '#111111',
  },
  {
    fg = fg.bright,
    bg = '#000000',
  },
}

function M.apply_highlight_to_dynamic_foldcolumn(line_number)
  local current_line_level = vim.fn.foldlevel(line_number)

  local highlight = highlight_levels[(
    current_line_level % (
      #highlight_levels - 1
    )
  ) + 1]

  vim.api.nvim_set_hl(0, 'FoldColumnDynamic', highlight)

  return ' '
end

return M
