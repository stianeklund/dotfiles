set nocompatible              " be iMproved, required
set relativenumber
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set expandtab
set nowrap
set mouse=a

" Set GUI font
set gfn=DejaVu_Sans_Mono_for_Powerline:h10:cANSI

" Mapleader from \ to ,
let mapleader=","

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
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}  " HTML expansion
Plugin 'tpope/vim-surround'                 "
Plugin 'godlygeek/tabular'                  " :Tabularize / arg
Plugin 'plasticboy/vim-markdown'            "
Plugin 'scrooloose/syntastic'               " Syntax all the things
Plugin 'morhetz/gruvbox.git'                "
Plugin 'scrooloose/nerdtree'                "
Plugin 'lokaltog/vim-easymotion'            " Because normal movement is slow
call vundle#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

syntax enable

" set term colors to 256
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
set background=dark
colorscheme gruvbox

" Enable syntastic statusline changes
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Colemak remapping
noremap n j|noremap <C-w>n <C-w>j|noremap <C-w><C-n> <C-w>j
noremap e k|noremap <C-w>e <C-w>k|noremap <C-w><C-e> <C-w>k
noremap s h
noremap t l
noremap f e
noremap k n
noremap K N
noremap U <C-r>
noremap j <Nop>

" NERDTree changes for colemak
" Default ("e"), interferes with navigation
let g:NERDTreeMapOpenExpl = "j"

" CTRL N to open NERDTree
map <C-n> :NERDTreeToggle<CR>

" Easymotion
map <Leader> <Plug>(easymotion-prefix)
