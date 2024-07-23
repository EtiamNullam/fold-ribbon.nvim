local M =  {}

M.version = '0.1.0'

local function is_window_floating(window_id)
  return vim.api.nvim_win_get_config(window_id).relative ~= ""
end

local function warn(message)
  vim.notify(
    '[fold-ribbon]: ' .. message,
    vim.log.levels.WARN
  )
end

local function update_statuscolumn()
  vim.o.statuscolumn = '%s'
    .. '%#FoldColumnDynamic#'
    .. "%{v:lua.require('fold-ribbon').apply_highlight_to_dynamic_foldcolumn(v:lnum)}"
    .. (vim.o.number and '%## %=%l ' or '')
end

local function register_autocommands()
  local group_id = vim.api.nvim_create_augroup(
    'FoldRibbon',
    { clear = true }
  )

  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'number,relativenumber',
    group = group_id,
    callback = function()
      if not is_window_floating(0) then
        update_statuscolumn()
      end
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group_id,
    callback = function()
      if not is_window_floating(0) then
        update_statuscolumn()
      end
    end,
  })
end

local fg = {
  bright = '#ffffff',
  dark = '#000000',
}

local highlight_steps = {
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

function M.setup(options)
  if vim.fn.has('nvim-0.9') == 0 then
    warn('Configuration of "statuscolumn" requires latest version of neovim nightly (>= 0.9)')

    return
  end

  if options then
    if options.highlight_steps then
      if type(options.highlight_steps) == 'table' then
        highlight_steps = options.highlight_steps
        vim.print(highlight_steps)
      else
        warn('"highlight_steps" must be a table')
      end
    end
  end

  vim.o.foldcolumn = '0'

  register_autocommands()

  -- TODO iterate over all windows
  if not is_window_floating(0) then
    update_statuscolumn()
  end
end

function M.apply_highlight_to_dynamic_foldcolumn(line_number)
  local current_line_level = vim.fn.foldlevel(line_number)

  local highlight = highlight_steps[(
    current_line_level % (
      #highlight_steps
    )
  ) + 1]

  vim.api.nvim_set_hl(0, 'FoldColumnDynamic', highlight)

  return ' '
end

return M
