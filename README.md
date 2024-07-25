# fold-ribbon.nvim

Takes control over `statuscolumn` to indicate fold depth at a glance.

Inspired by Xcode fold indicator.

https://github.com/CodeEditApp/CodeEditTextView/issues/43
https://github.com/kevinhwang91/nvim-ufo/issues/24

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
