return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip', -- snippet engine
    'saadparwaiz1/cmp_luasnip', -- for autocompletion
    'rafamadriz/friendly-snippets', -- useful snippets
    'onsails/lspkind.nvim', -- vs-code like pictograms
  },
  config = function()
    local cmp = require('cmp')

    local luasnip = require('luasnip')

    local lspkind = require('lspkind')

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
        ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
        ['<C-e>'] = cmp.mapping.abort(), -- close completion window
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if require('copilot.suggestion').is_visible() then
            require('copilot.suggestion').accept()
          elseif cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = vim.schedule_wrap(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- snippets
        { name = 'buffer' }, -- text within current buffer
        { name = 'path' }, -- file system paths
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        -- Keep the default formatting fields and expandable_indicator
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = '...',
          preset = 'codicons',
          show_labelDetails = true, -- show labelDetails in menu.
          menu = {
            buffer = '[Buffer]',
            nvim_lsp = '[LSP]',
            luasnip = '[LuaSnip]',
            nvim_lua = '[Lua]',
            latex_symbols = '[Latex]',
          },
        }),
      },
    })
  end,
}
