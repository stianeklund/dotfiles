call plug#begin('~/.vim/bundle')

" Plugins
Plug 'morhetz/gruvbox'            " Gruvbox for Vim
Plug 'plasticboy/vim-markdown'        " Markdown support
Plug 'kazark/vim-log4x'
Plug 'godlygeek/tabular'              " :Tabularize / arg
Plug 'lokaltog/vim-easymotion'        " Because normal movement is slow
Plug 'tpope/vim-fugitive'             " Git from Vim
call plug#end()

filetype indent plugin on
syntax enable

autocmd BufNewFile,BufRead *log* set filetype=log
autocmd BufNewFile,BufRead *log*.txt set syntax=log4x

set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set nowrap
set mouse=a
set clipboard=unnamedplus
set backspace=indent,eol,start
set number
set relativenumber
set backup
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" 256 Colors
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
set background=dark
colorscheme gruvbox

" Set airline status line
set laststatus=2
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'

" Relative numbers based on mode
augroup linenumbers
  autocmd!
  autocmd BufEnter *    :set relativenumber
  autocmd BufLeave *    :set number norelativenumber
  autocmd WinEnter *    :set relativenumber
  autocmd WinLeave *    :set number norelativenumber
  autocmd InsertEnter * :set number norelativenumber
  autocmd InsertLeave * :set relativenumber
  autocmd FocusLost *   :set number norelativenumber
  autocmd FocusGained * :set relativenumber
augroup END

" Highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Mapleader from \ to space
let mapleader="\<Space>"

" Use leader for frequently used actions
" <Space>w to save file
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>qq :q!<CR>

" Easy copy paste
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Easymotion (for fast navigation)
map <Leader><Leader> <Plug>(easymotion-prefix)
