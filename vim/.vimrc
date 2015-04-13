set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle.vim
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'mattn/gist-vim'
Plugin 'vim-scripts/vcscommand.vim'

filetype plugin indent on    " required

syntax enable

let mapleader = ","

set autoread
set expandtab
set hlsearch
set incsearch
set ignorecase
set ruler
set shiftwidth=4
set smartindent
set tabstop=4

set colorcolumn=80
let &colorcolumn=join(range(81,999),",")

set background=dark
let g:solarized_termcolors=256
colorscheme solarized

" --------------------
"  VCS (plugin)
" --------------------
let g:VCSCommandDeleteOnHide=1
map <leader>cd :VCSDiff<CR>
map <leader>cl :VCSLog<CR>
map <leader>ca :VCSAnnotate<CR>
map <leader>cv :VCSVimDiff<CR>
" -------------------
"  END VCS (plugin)
" --------------------
