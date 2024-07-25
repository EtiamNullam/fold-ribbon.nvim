<h1>
  fold-ribbon.nvim
  <a href="https://github.com/EtiamNullam/fold-ribbon.nvim/tags" alt="Latest SemVer tag">
    <img src="https://img.shields.io/github/v/tag/EtiamNullam/fold-ribbon.nvim" />
  </a>
  <a href="LICENSE" alt="License">
    <img src="https://img.shields.io/github/license/EtiamNullam/fold-ribbon.nvim" />
  </a>
</h2>

This plugin for [neovim](https://neovim.io) allows you to see fold depth at a glance.

![image](https://github.com/user-attachments/assets/26ae8233-e1f7-48ec-9fca-1aa754e2ff64)

You can [let `fold-ribbon` take control over `statuscolumn`](#give-full-control-over-statuscolumn) or [use the API if you already use custom `statuscolumn`](#get-component-for-use-in-statuscolumn) (not to be confused with `statusline`).

Indirectly inspired by Xcode fold indicator.

https://github.com/kevinhwang91/nvim-ufo/issues/24

## Requirements

- `neovim` >= `0.10`

## Installation

`lazy.nvim`:

```lua
{
  'EtiamNullam/fold-ribbon.nvim',
  config = function()
    require('fold-ribbon').setup()
  end,
},
```

`vim-plug`:

```vim
Plug 'EtiamNullam/fold-ribbon'
```

## Usage

### Give full control over `statuscolumn`

Useful when you do not have the `statuscolumn` configured or need a simple solution.

```lua
require('fold-ribbon').setup()
```

### Get component for use in `statuscolumn`

Choose this if you are already have a custom `statuscolumn` and you want to add `fold-ribbon` to it.

```lua
local ribbon = require('fold-ribbon').get_ribbon()

vim.o.statuscolumn = '%l ' .. ribbon
```

### Setup options

Here are all available configuration options with their defaults:

```lua
require('fold-ribbon').setup {
  disable = false, -- Toggle to disable the plugin after it was started.
  align_line_number_right = true, -- Align line numbers to the right, as it is by default.
  excluded_filetype_patterns = { -- List of filetype regex patterns where plugin will not be displayed.
    'startify',
    'help',
  },
  excluded_path_patterns = {}, -- List of path regex patterns where plugin will not be displayed.
  highlight_steps = { -- Defines colors at each fold level.
    -- If there are more fold levels than steps defined they will loop.
    -- It has to be a table of highlights just as you would use in `vim.api.nvim_set_hl`.
    {
      fg = '#000000',
      bg = '#eeeeee',
    },
    {
      fg = '#000000',
      bg = '#dddddd',
    },
    {
      fg = '#000000',
      bg = '#cccccc',
    },
    {
      fg = '#000000',
      bg = '#bbbbbb',
    },
    {
      fg = '#000000',
      bg = '#aaaaaa',
    },
    {
      fg = '#ffffff',
      bg = '#999999',
    },
    {
      fg = '#ffffff',
      bg = '#888888',
    },
    {
      fg = '#ffffff',
      bg = '#777777',
    },
    {
      fg = '#ffffff',
      bg = '#666666',
    },
    {
      fg = '#ffffff',
      bg = '#555555',
    },
    {
      fg = '#ffffff',
      bg = '#444444',
    },
    {
      fg = '#ffffff',
      bg = '#333333',
    },
    {
      fg = '#ffffff',
      bg = '#222222',
    },
    {
      fg = '#ffffff',
      bg = '#111111',
    },
    {
      fg = '#ffffff',
      bg = '#000000',
    },
  },
}
```

#### Use custom highlight colors

Simple example how to override `highlight_steps`:

```lua
require('fold-ribbon').setup {
  highlight_steps = {
    { bg = '#ff8888' },
    { bg = '#88ff88' },
    { bg = '#8888ff' },
  }
}
```
