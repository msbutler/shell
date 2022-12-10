" create red line at max line
set colorcolumn=80

" line numbers
set number

" set status bar
set laststatus=2

set hlsearch 
set noswapfile 
set ignorecase 
" set incsearch 

syntax on

if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

" max char length of line
set textwidth=79

" Visually wraps long line in the terminal pane
set wrap

