-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({
        "ellisonleao/gruvbox.nvim",
        as = 'gruvbox',
        config = function()
            vim.cmd('colorscheme gruvbox')
        end

    })

    use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    -- use( 'p00f/nvim-ts-rainbow' )
    use( 'nvim-treesitter/playground' )
    use( 'theprimeagen/harpoon' )
    use( 'mbbill/undotree' )
    use( 'tpope/vim-fugitive' )
    use( 'vim-airline/vim-airline' )
    use( 'vim-airline/vim-airline-themes' )
    use( 'preservim/nerdtree' )
    use( 'ryanoasis/vim-devicons' )
    use( 'Yggdroot/indentline' )
    use( 'lewis6991/gitsigns.nvim' )
    use( 'nvim-tree/nvim-web-devicons' )
    use( 'romgrk/barbar.nvim' )
    use( 'nvim-lua/plenary.nvim' )
    use( 'dense-analysis/ale' )
    use( 'stevearc/dressing.nvim' )
    use( 'airblade/vim-gitgutter' )
    use( 'lervag/vimtex' )
    -- use( 'folke/lsp-colors.nvim' )
    use( 'folke/trouble.nvim' )
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- LSP Support
            {'neovim/nvim-lspconfig'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    })
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })

end)

