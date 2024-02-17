return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = function()
      local icons = require('ergou.util.icons')
      return {
        options = {
          theme = 'catppuccin',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            {
              'diff',
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            {
              'buffers',
              symbols = icons.file.symbols,
            },
          },
          lualine_c = {
            -- Disable the default sections
            { ['buffers'] = {} },
          },
          lualine_x = {
            {
              'rest',
              icon = icons.others.rest,
              fg = '#428890',
            },
            {
              'copilot',
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return icons.others.clock .. os.date('%R')
            end,
          },
        },
      }
    end,
  },
}
