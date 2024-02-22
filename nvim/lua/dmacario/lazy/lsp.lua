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

return{
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
    -- Ensure lsp "writes on top of" fugitive
    {'tpope/vim-fugitive'},
    {'nvim-tree/nvim-web-devicons'},
    -- Null-ls
    {'jose-elias-alvarez/null-ls.nvim', dependencies = {'nvim-lua/plenary.nvim'}}
  },
  config = function()
    local lsp_zero = require('lsp-zero')
    lsp_zero.extend_lspconfig()
    lsp_zero.preset('recommended')
    vim.diagnostic.config({
      virtual_text = {
        prefix = '●', -- Could be '■', '▎', 'x'
      }
    })

    require('mason').setup({
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      }
    })
    require('mason-lspconfig').setup({
      ensure_installed = {
        "cssls",
        "eslint",
        "html",
        "jsonls",
        "tsserver",
        "pyright",
        "jedi_language_server",
        -- "tailwindcss",
        "bashls",
        "dockerls",
        "ltex",
        "texlab",
        "marksman",
        "lua_ls",
        "matlab_ls",
        "rust_analyzer",
        "gopls",
        "clangd",
        "cmake",
        "efm",
      },
      handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
      }
    })

    lsp_zero.set_preferences({})

    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps({buffer = bufnr})
      -- Defaults:
      -- local opts = {buffer = bufnr, remap = false}
      -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
      -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
      -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
      -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
      -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
      -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
      -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end)

    -- Setup LSPs
    require('lspconfig').lua_ls.setup {
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
              }
            }
          })

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end
    }
    require('lspconfig').rust_analyzer.setup({
      cmd = {
        "rustup", "run", "stable", "rust-analyzer",
      }
    })
    require('lspconfig').ltex.setup({
      filetypes = {"latex", "tex"},
      settings = { -- See https://valentjn.github.io/ltex/settings.html for full list
        ltex = {
          enabled = {
            "bibtex",
            "context",
            "context.tex",
            "html",
            "latex",
            "org",
            "restructuredtext",
            "rsweave",
            -- "markdown",
          },
          language = "en-US",
          additionalRules = {
            enablePickyRules = false,
            motherTongue = "it",
          }
        },
      },
    })

    -- Autocompletion (cmp)
    local cmp = require('cmp')
    local cmp_select = {behavior = cmp.SelectBehavior.Select}

    cmp.setup({
      sources = {
        -- The `keyword_length` indicates after how many chars that source is activated
        { name = 'path' },                         -- file paths
        { name = 'nvim_lsp', keyword_length = 2 }, -- from language server
        { name = 'nvim_lsp_signature_help'},       -- display function signatures with current parameter emphasized
        { name = 'nvim_lua', keyword_length = 3},  -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer', keyword_length = 4 },   -- source current buffer
        { name = 'vsnip', keyword_length = 4 },    -- nvim-cmp source for vim-vsnip 
        { name = 'calc'},                          -- source for math calculation
      },
      mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),
        -- Activate Tab functionality
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        -- Close autocompletion menu with ctrl + e
        ['<C-e>'] = cmp.mapping.close(),
      }),
      window = {
        -- Autocomplete window graphical settings
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          -- Source
          local menu_icon = {
            nvim_lsp = 'λ',
            vsnip = '⋗',
            buffer = 'Ω',
            path = '',
          }
          vim_item.menu = menu_icon[entry.source.name]
          return vim_item
        end,
      },
    })

  end
}
