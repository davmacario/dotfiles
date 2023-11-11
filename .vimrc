set nocompatible              " required
filetype on                  " required
syntax on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'dense-analysis/ale'
Plugin 'Valloric/YouCompleteMe'
Plugin 'psf/black'
Plugin 'vim-syntastic/syntastic'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'Yggdroot/indentline'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax enable
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
" Hybrid line numbers
set number relativenumber
filetype indent on
set autoindent
set cursorline
set showcmd
set t_Co=256    " 256 bit colors
set foldmethod=indent   " Code folding
set foldlevel=99    " Defalut: unfolded
" Remap 'space' to 'za' for unfolding code
nnoremap <space> za
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
let mapleader = ","

" Remap keys for split-view
nnoremap <leader>h <c-w>h
nnoremap <leader>l <c-w>l
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

" Python file settings (some are redundant, but global changes will not affect
" them
au BufNewFile, BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" Markdown file settings
let g:markdown_recommended_style=0
autocmd BufNewFile, BufRead *.md
    \ setlocal tabstop=2
    \ setlocal softtabstop=2
    \ setlocal shiftwidth=2
    \ setlocal expandtab
    \ setlocal autoindent
    \ setlocal fileformat=unix
    \ setlocal spell
    \ setlocal textwidth=80

let g:ale_linters = {
    \'python': ['Black'],
    \'markdown': ['writegood'],
    \}

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_linters_explicit = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

" Autocomplete settings (YouCompleteMe)
let g:ycm_autoclose_preview_window_after_completion=1

" Tab plugin settings
let g:indentLine_color_term = 238

" Black Python formatter settings
let g:black_virtualenv='~/.vim/black'

" Format with black when saving
autocmd BufWritePre *.py execute ':Black'

" Lightline colorscheme:
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }
set laststatus=2

" Color scheme
colorscheme gruvbox
set background=dark     " dark background

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

"let g:NERDTreeDirArrowExpandable = '>'
"let g:NERDTreeDirArrowCollapsible = 'v'

let NERDTreeShowHidden=1

" Shortcuts
map <C-o> :NERDTreeToggle<CR>

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
" zo: open fold under the cursor
" zc: close fold under cursor
" zR: open all folds
" zM: close all folds
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" }}}



