" LTM-compatible .vimrc

set nocompatible
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set smarttab
set fileformats=unix,dos
" Intelligent automatic intending when adding more text to a paragraph or block of code
set autoindent
set smartindent
"set cindent

" don't move comments to the first column (irritating as hell)
inoremap # X#

set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan
set showmode
set autoread              " read open files again when changed outside Vim
set autowrite             " write a modified buffer on each :next , ...
"statusline
"set laststatus=2
"set statusline=%1*\File:\ %*%f%1*%5m%*%=\L%-5l\ \C%-4c%5p%%\ [%L\ \lines]

set backspace=indent,eol,start
" Fix the backspace key
set t_kb=

" Clear search highlighting after the search
map <C-X> :let @/=""<CR>

syntax on

