set nobackup
set nowritebackup
set noswapfile
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smarttab
filetype indent on
filetype on
filetype plugin on

if has("autocmd")
	"au FileType cpp,c,java,sh,pl,php,python,ruby set autoindent
	""au FileType cpp,c,java,sh,pl,php,py,rb set smartindent
	au FileType cpp,c,java,sh,pl,php set cindent
	au BufRead *.py set cinwords=if,elif,else,for,while,try,except,finally,def,class
	au BufRead *.rb set cinwords=if,elsif,else,unless,for,while,begin,rescue,def,class,module
	"au BufRead *.py set smartindent
	"cinwords=if,elif,else,for,while,try,except,finally,def,class
	""au BufRead *.rb set smartindent	cinwords=if,elsif,else,unless,for,while,begin,rescue,def,class,module
endif
 
syntax on
"set background=dark
""hi Normal ctermfg=grey ctermbg=darkgrey
hi PreProc ctermfg=magenta
hi Statement ctermfg=darkYellow
hi Type ctermfg=blue
hi Function ctermfg=blue
hi Identifier ctermfg=darkBlue
hi Special ctermfg=darkCyan
hi Constant ctermfg=darkCyan
hi Comment ctermfg=darkGreen
au BufRead,BufNewFile *.rb hi rubySymbol ctermfg=green
