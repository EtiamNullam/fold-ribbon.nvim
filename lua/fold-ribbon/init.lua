local M = {}

M.version = '0.4.0'

M.is_active = false

local function is_window_floating(window_id)
  return vim.api.nvim_win_get_config(window_id).relative ~= ''
end

local function create_line_number_statuscolumn(show_line_number, use_relative_line_numbers)
  if show_line_number and use_relative_line_numbers then
    return '%{v:virtnum > 0 ? "" : line(".") == v:lnum ? v:lnum : v:relnum}'
  end

  if show_line_number then
    return '%{v:virtnum > 0 ? "" : v:lnum}'
  end

  if use_relative_line_numbers then
    return '%{v:virtnum > 0 ? "" : v:relnum}'
  end

  return ''
end

local saved_statuscolumn = ''

local function update_statuscolumn()
  vim.o.foldcolumn = '0'
  vim.o.statuscolumn = '%s'
    .. create_line_number_statuscolumn(vim.o.number, vim.o.relativenumber)
    .. ' %='
    .. M.get_ribbon()
    .. ' '
end

local autocommand_group = 'FoldRibbon'

local function register_autocommands()
  local group_id = vim.api.nvim_create_augroup(
    autocommand_group,
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

  vim.api.nvim_create_autocmd({
    'WinEnter',
    'BufEnter',
  }, {
    group = group_id,
    callback = function()
      if not is_window_floating(0) then
        update_statuscolumn()
      end
    end,
  })
end

local function remove_autocommands()
  vim.api.nvim_clear_autocmds { group = autocommand_group }
end

local fg = {
  bright = '#ffffff',
  dark = '#000000',
}

local highlight_steps = {
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
  if vim.fn.has('nvim-0.10') == 0 then
    require('fold-ribbon.log').error(
      'Configuration of "statuscolumn" requires neovim version of at least 0.10'
    )

    return
  end

  options = options or {}

  if options.disable then
    remove_autocommands()
    vim.o.statuscolumn = saved_statuscolumn

    return
  end

  if not M.is_active then
    saved_statuscolumn = vim.o.statuscolumn
  end

  M.is_active = not options.disable

  if options.highlight_steps then
    if type(options.highlight_steps) == 'table' then
      highlight_steps = options.highlight_steps
    else
      require('fold-ribbon.log').warn(
        'Invalid parameter for "highlight_steps", must be a table of highlights'
      )
    end
  end

  register_autocommands()

  if not is_window_floating(0) then
    update_statuscolumn()
  end
end

local function get_highlight(line_number, level)
  local has_no_fold = level == 0

  if has_no_fold then
    local is_cursorline = vim.fn.line('.') == line_number

    if is_cursorline then
      return { link = 'CursorLineNr' }
    else
      return { link = 'LineNr' }
    end
  end

  local step_index = (
    (level - 1) % #highlight_steps
  ) + 1

  return highlight_steps[step_index]
end

function M.apply_highlight(line_number)
  local current_line_level = vim.fn.foldlevel(line_number)

  vim.api.nvim_set_hl(0, 'FoldColumnDynamic', get_highlight(line_number, current_line_level))

  return ' '
end

---@return string
function M.get_ribbon()
  return '%#FoldColumnDynamic#'
    .. '%{v:lua.require("fold-ribbon").apply_highlight(v:lnum)}'
    .. '%##'
end

return M
