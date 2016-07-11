set nocompatible              " be iMproved, required
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set expandtab
set nowrap
set mouse=a
set backspace=indent,eol,start
" Set GUI font
set gfn=DejaVu_Sans_Mono_for_Powerline:h10:cANSI

filetype off " required
filetype indent plugin on

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call pathogen#helptags()
execute pathogen#infect()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" My plugins
Plugin 'tpope/vim-fugitive'                 " Git wrapper
Plugin 'tpope/vim-surround'                 "
Plugin 'godlygeek/tabular'                  " :Tabularize / arg
Plugin 'plasticboy/vim-markdown'            "
Plugin 'scrooloose/syntastic'               " Syntax all the things
Plugin 'morhetz/gruvbox.git'                "
Plugin 'scrooloose/nerdtree'                "
Plugin 'lokaltog/vim-easymotion'            " Because normal movement is slow
Plugin 'racer-rust/vim-racer'
Plugin 'rust-lang/rust.vim'
Plugin 'vim-airline/vim-airline'
call vundle#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" Mapleader from \ to ,
let mapleader="\<Space>"

" Use leader for frequently used actions
" <Space>w to save file
nnoremap <Leader>w :w<CR>

" easy copy paste
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" jj produces Esc
imap jj <Esc>

syntax enable

" set term colors to 256
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
set background=dark
colorscheme gruvbox

set number
set relativenumber

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

" set airline status line
set laststatus=2
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'

" Highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Easymotion
map <Leader> <Plug>(easymotion-prefix)

