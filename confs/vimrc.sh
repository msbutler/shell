" create red line at max line
set colorcolumn=80

" line numbers
set number
set relativenumber

" set status bar
set laststatus=2

" ignore casing during search
set ignorecase 

" show partial matches
" set incsearch 

" display letters being typed into normal/visual mode at bottom of vim cli
set showcmd

" ensure l and h can move to next/last line
set whichwrap=lh

" make search iterations automatically center on the screen
nnoremap n nzz
nnoremap N Nzz

" [half] page toggle up and down center on the screen
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" delete to null register
noremap d "_d
noremap dd "_dd

" cut
noremap r d
noremap rr dd

" exit insert mode more easily
inoremap jk <esc>

" Delete current line without yanking the line breaks
nnoremap dil ^d$

syntax on

" ensure vim can connect to system clipboard
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

" Visually wraps long line in the terminal pane
set wrap

" attempt to make tabs 2 spaces in width
set noexpandtab
set tabstop=2
set shiftwidth=2

" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
" SI means insert mode
let &t_SI = "\e[6 q"

" EI means everywhere else
let &t_EI = "\e[2 q"
