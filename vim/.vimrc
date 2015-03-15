set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#begin()

Plugin 'gmark/Vundle.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'vim-scripts/vcscommand.vim'
Plugin '0rca/vim-mikrotik'
Plugin 'vim-scripts/showmarks--Politz'
Plugin 'mattn/gist-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()            " required

filetype plugin indent on    " required
syntax on

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set autoread
set hlsearch
set incsearch
set ignorecase

set colorcolumn=80
" let &colorcolumn=join(range(81,999),",")
highlight ColorColumn guibg=#2c2d27
set number
" highlight LineNr ctermfg=grey

set background=dark
let g:solarized_visibility="high"
let g:solarized_contrast="high"
let g:solarized_termcolors=256
colorscheme solarized
