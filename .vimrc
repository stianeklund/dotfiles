" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/bundle')
"call plug#begin('~/vimfiles/bundle')


set nocompatible              " be iMproved, required
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set expandtab
set nowrap
set mouse=a
set clipboard=unnamedplus
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

" Fix bug with Vundle
set shell=/bin/bash
" Set the runtime path to include Vundle and initialize
call pathogen#helptags()
execute pathogen#infect()

" Plugins
Plug 'morhetz/gruvbox'            " Gruvbox for Vim
Plug 'plasticboy/vim-markdown'        " Markdown support
Plug 'kazark/vim-log4x'
Plug 'godlygeek/tabular'              " :Tabularize / arg
Plug 'scrooloose/syntastic'           " Syntax all the things
Plug 'lokaltog/vim-easymotion'        " Because normal movement is slow
Plug 'tpope/vim-fugitive'             " Git from Vim
call plug#end()

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

" Let ctrl-j produce Esc
" inoremap <C-j> <Esc>
" vnoremap <C-j> <Esc>

" Mapleader from \ to space
let mapleader="\<Space>"

" Use leader for frequently used actions
" <Space>w to save file
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>qq :q!<CR>

" Easymotion (for fast navigation)
map <Leader> <Plug>(easymotion-prefix)

" Easy copy paste
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

