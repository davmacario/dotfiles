local kind_icons = {
  Class = " ",
  Method = " ",
  Function = "ƒ ",
  Text = " ",
  Constructor = " ",
  Field = "󰄶 ",
  File = " ",
  Variable = " ",
  Module = "󰏗 ",
  Keyword = "󰌋 ",
  Interface = "󰜰 ",
  Property = "󰜢 ",
  Unit = " ",
  Value = "󰎠 ",
  Snippet = " ",
  Enum = " ",
  EnumMember = " ",
  Color = "󰏘 ",
  Reference = " ",
  Folder = "󰉋 ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = "󰅲 ",
}

return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-e>"] = cmp.mapping.close(),
        }),
        sources = {
          { name = "path" },                    -- file paths
          { name = "nvim_lsp",               keyword_length = 2 }, -- from language server
          { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
          { name = "nvim_lua",               keyword_length = 3 }, -- complete neovim's Lua runtime API such vim.lsp.*
          { name = "luasnip",                keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
          { name = "buffer",                 keyword_length = 4 }, -- source current buffer
          { name = "calc" },                    -- source for math calculation
        },
        formatting = {
          fields = { "menu", "abbr", "kind" },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            -- Source
            local menu_icon = {
              nvim_lsp = "λ",
              vsnip = "⋗",
              buffer = "Ω",
              path = "",
            }
            vim_item.menu = menu_icon[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
}
