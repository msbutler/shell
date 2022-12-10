" create red line at max line
set colorcolumn=80

" line numbers
set number
set relativenumber

" set status bar
set laststatus=2



set noswapfile 

" ignore casing during search
set ignorecase 

" show partial matches
" set incsearch 

" make search iterations automatically center on the screen
nnoremap n nzz
nnoremap N Nzz

" exit insert mode more easily
inoremap jk <esc>

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

