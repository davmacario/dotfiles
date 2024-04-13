return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
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
          "grammarly",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- local opts = {buffer = bufnr, remap = false}
      -- Keymaps
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, {})
      vim.keymap.set("n", "[d", vim.diagnostic.goto_next, {})
      vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {})

      -- Border of 'hover' box
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      local lspconfig = require("lspconfig")
      lspconfig.grammarly.setup({
        capabilities = capabilities,
        filetypes = { "markdown", "latex", "tex" },
        init_options = { clientId = "client_BaDkMgx4X19X9UxxYRCXZo" },
      })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.eslint.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.jedi_language_server.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.ltex.setup({
        capabilities = capabilities,
        filetypes = { "latex", "tex" },
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
              motherTongue = "it-IT",
            },
          },
        },
      })
      lspconfig.texlab.setup({ capabilities = capabilities })
      lspconfig.marksman.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if
              not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
          then
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              },
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
      })
      lspconfig.matlab_ls.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        cmd = {
          "rustup",
          "run",
          "stable",
          "rust-analyzer",
        },
      })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
      lspconfig.cmake.setup({ capabilities = capabilities })
      lspconfig.efm.setup({ capabilities = capabilities })
    end,
  },
}
