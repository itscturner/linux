"#################"
"#     VIMRC     #"
"#################"

" Check Colors: ':so $VIMRUNTIME/syntax/hitest.vim'

" Enable Filetype Detection: "
filetype on

" Enable / Load Plugins For The Detected File Type: "
filetype plugin on

" Syntax Highlighting: "
syntax on

" Line Numbers: "
set number

" Allow Backspacing Over Everything In Insert Mode: "
set bs=indent,eol,start

" Tab Spaces: "
set tabstop=4

" Tab Space Characters: "
set expandtab

" Ignore Capital Letters During Search: "
set ignorecase

" Override Ignore Characters If Searching For Capital Letters: "
set smartcase

" Set Highlighting When Searching: "
set hlsearch

" Search History Size: "
set history=100

" Bell Noise: "
set belloff=all

" File Types: "
autocmd BufNewFile,BufRead *.txt set syntax=sh

" Status Line: "
set laststatus=2
set statusline=
" Left Side: "
set statusline+=File:\ %f\ --\ Filetype:\ %y
" Divide Left and Right Side: "
set statusline+=%=
" Right Side: "
set statusline+=Column:\ %c\ --\ Current\ Line:\ %l\ --\ Total\ Lines:\ %L\ --\ Percentage:\ %P
