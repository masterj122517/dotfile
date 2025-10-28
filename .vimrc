syntax on
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set number
set hlsearch
set incsearch
set ruler
set noswapfile
set clipboard=unnamedplus
set undofile
set undodir=$HOME/.vimundo
set ignorecase
set wildmenu 
set relativenumber 
set nobackup
set backspace=indent,eol,start
set whichwrap=b,s,<,>,h
set nowrap 
set mouse=a
colorscheme desert

nnoremap ; :
nnoremap <ESC> :nohlsearch<CR>
nnoremap - :Ex<CR>

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

inoremap ( ()<Left>
inoremap (<CR> (<CR>)<Esc>O
inoremap (( (
inoremap () ()

inoremap [ []<Left>
inoremap [<CR> [<CR>]<Esc>O
inoremap [[ [
inoremap [] []


nnoremap + <C-a>
nnoremap _ <C-x>
nnoremap , @q 

nnoremap <BS> "_ciw
vnoremap <BS> "_d

set timeoutlen=300

