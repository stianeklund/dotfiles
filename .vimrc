set nocompatible              " be iMproved, required
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set expandtab
set nowrap
set mouse=a
set backspace=indent,eol,start " More sensible backspace
set gfn=DejaVu_Sans_Mono_for_Powerline:h10:cANSI
set number
set relativenumber
syntax enable


filetype off " required
filetype indent plugin on

set backup                  " Backups are nice ...
if has('persistent_undo')   "
    set undofile            " So is persistent undo ...
    set undolevels=1000     " Maximum number of changes that can be undone
    set undoreload=10000    " Maximum number lines to save for undo on a buffer reload
endif

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call pathogen#helptags()
execute pathogen#infect()

" Vundle Plugins
Plugin 'gmarik/Vundle.vim'              " Let Vundle manage Vundle, required
" Color schemes                         ************************************
Plugin 'morhetz/gruvbox.git'            " Gruvbox for Vim
" Language specific                     ************************************
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'
Plugin 'plasticboy/vim-markdown'        " Markdown support
"Other plugins                          ************************************
Plugin 'godlygeek/tabular'              " :Tabularize / arg
Plugin 'scrooloose/syntastic'           " Syntax all the things
Plugin 'lokaltog/vim-easymotion'        " Because normal movement is slow
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'             " Git from Vim
" 8080 assembly syntax highlighting
Plugin 'oraculo666/vim-m80'
call vundle#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

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

" Let jj produce Esc
imap jj <Esc>

" Mapleader from \ to space
let mapleader="\<Space>"

" Use leader for frequently used actions
" <Space>w to save file
nnoremap <Leader>w :w<CR>

" Easymotion (for fast navigation)
map <Leader> <Plug>(easymotion-prefix)

" Easy copy paste
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Enable Racer for Rust and set Rust src path
set hidden
let g:racer_cmd = "</home/stian.cargo/racer"
let $RUST_SRC_PATH="/usr/local/src/rust/src/"
