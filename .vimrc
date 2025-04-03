set nocompatible
filetype on
syntax on

syntax enable
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
" Hybrid line numbers
set number relativenumber
filetype plugin indent on
set autoindent
set cursorline
set showcmd
set t_Co=256    " 256 bit colors
set foldmethod=indent   " Code folding
set foldlevel=99    " Defalut: unfolded
" Remap 'space' to 'za' for unfolding code
nnoremap , za
set encoding=UTF-8
set updatetime=100
set backspace=indent,eol,start
" Share clipboard
set clipboard=unnamed
set path+=**
set hlsearch
set ignorecase
set smartcase

" Leader key: Space
let mapleader = " "

" Remap keys for split-view
nnoremap <leader>h <c-w>h
nnoremap <leader>l <c-w>l
nnoremap <leader>k <c-w>k
nnoremap <leader>j <c-w>j
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
" Remap keys for navigating tabs
nnoremap H :bn<CR>
nnoremap L :bp<CR>
" Colorscheme
colorscheme retrobox
set background=dark
" Netrw
nnoremap <leader>pv :Explore<CR>

" Jump to last position when opening file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
