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
Bundle 'Valloric/YouCompleteMe'
Plugin 'psf/black'
Plugin 'vim-syntastic/syntastic'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

syntax enable
set tabstop=4
set shiftwidth=4
set expandtab
set number
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

let g:ale_linters = {'python': ['Black']}

" Autocomplete settings (YouCompleteMe)
let g:ycm_autoclose_preview_window_after_completion=1

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



