local M = {}

M.version = '0.4.0'

M.is_active = false

local default_options = {
  align_line_number_right = true,
  disable = false,
  excluded_filetypes = {
    'startify',
    'help',
  },
}

M.active_options = default_options

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

---@type table<integer, string>
local saved_statuscolumn_per_window = {}

---@param window_id integer
local function update_statuscolumn(window_id)
  vim.api.nvim_set_option_value('foldcolumn', '0', { win = window_id })

  local line_number_segment = create_line_number_statuscolumn(
    vim.api.nvim_get_option_value('number', { win = window_id }),
    vim.api.nvim_get_option_value('relativenumber', { win = window_id })
  )

  local statuscolumn = M.get_ribbon() .. ' '

  if line_number_segment ~= '' then
    if M.active_options.align_line_number_right then
      statuscolumn = '%='
        .. line_number_segment
        .. ' '
        .. statuscolumn
    else
      statuscolumn = line_number_segment
        .. ' %='
        .. statuscolumn
    end
  end

  statuscolumn = '%s' .. statuscolumn

  vim.api.nvim_set_option_value('statuscolumn', statuscolumn, { win = window_id })
end

local autocommand_group = 'FoldRibbon'

---@param window_id integer
---@return boolean
local function is_valid_window_for_ribbon(window_id, file_path)
  if is_window_floating(window_id) then
    return false
  end

  for _, excluded_filetype in pairs(M.active_options.excluded_filetypes) do
    local is_excluded = excluded_filetype == vim.o.filetype

    if is_excluded then
      return false
    end
  end

  return true
end

local function register_autocommands()
  local group_id = vim.api.nvim_create_augroup(
    autocommand_group,
    { clear = true }
  )

  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'number,relativenumber',
    group = group_id,
    callback = function(event)
      local window_id = 0
      local buffer_id = event.buf
      local file_path = vim.api.nvim_buf_get_name(buffer_id)

      if is_valid_window_for_ribbon(window_id, file_path) then
        update_statuscolumn(window_id)
      end
    end,
  })

  vim.api.nvim_create_autocmd({
    'WinNew',
    'BufWinEnter',
  }, {
    group = group_id,
    callback = function(event)
      local window_id = 0

      if is_valid_window_for_ribbon(window_id, event.file) then
        update_statuscolumn(window_id)
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
  options = vim.tbl_deep_extend('keep', options, default_options)
  M.active_options = options

  local was_disabled_before = not M.is_active

  M.is_active = not options.disable

  local open_windows_ids = vim.api.nvim_list_wins()

  if options.disable then
    remove_autocommands()

    for _, window_id in pairs(open_windows_ids) do
      local saved_statuscolumn = saved_statuscolumn_per_window[window_id] or ''

      local buffer_id = vim.api.nvim_win_get_buf(window_id)
      local file_path = vim.api.nvim_buf_get_name(buffer_id)

      if is_valid_window_for_ribbon(window_id, file_path) then
        vim.api.nvim_set_option_value('statuscolumn', saved_statuscolumn, { win = window_id })
      end
    end

    saved_statuscolumn_per_window = {}

    return
  end


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

  for _, window_id in pairs(open_windows_ids) do
    local buffer_id = vim.api.nvim_win_get_buf(window_id)
    local file_path = vim.api.nvim_buf_get_name(buffer_id)

    if is_valid_window_for_ribbon(window_id, file_path) then
      if was_disabled_before then
        saved_statuscolumn_per_window[window_id] = vim.api.nvim_get_option_value('statuscolumn', { win = window_id })
      end

      update_statuscolumn(window_id)
    end
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
