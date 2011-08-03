set nobackup
set nowritebackup
set noswapfile
set lines=40
set columns=79
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smarttab
filetype indent on
filetype on
filetype plugin on
au BufEnter,BufRead *.py setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

