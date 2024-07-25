<h1>
  fold-ribbon.nvim
  <a href="https://github.com/EtiamNullam/fold-ribbon.nvim/tags" alt="Latest SemVer tag">
    <img src="https://img.shields.io/github/v/tag/EtiamNullam/fold-ribbon.nvim" />
  </a>
  <a href="LICENSE" alt="License">
    <img src="https://img.shields.io/github/license/EtiamNullam/fold-ribbon.nvim" />
  </a>
</h2>

Takes control over `statuscolumn` to indicate fold depth at a glance.

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

### Use custom highlight colors

You can define your own colors at each fold level. If there are more fold levels than amount of defined steps they will loop. `highlight_steps` has to be a table of highlights just as you would use in `vim.api.nvim_set_hl`.

```lua
require('fold-ribbon').setup {
  highlight_steps = {
    { bg = '#ff8888' },
    { bg = '#88ff88' },
    { bg = '#8888ff' },
  }
}
```

### Disable

You can toggle plugin by passing `disable = true` as option to `setup`.

```lua
require('fold-ribbon').setup {
  disable = true,
}
```
