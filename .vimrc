set nocompatible              " be iMproved, required
set number
set backspace=2
set tabstop=4
set shiftwidth=4
set expandtab
filetype on                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call pathogen#helptags()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

execute pathogen#infect()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Plugin 'git://github.com/jooize/vim-colemak.git' # Disabled because it screws up other stuff
Plugin 'git://github.com/tpope/vim-surround' 
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
syntax enable
set background=dark
"
" solarized additions
colorscheme solarized
let g:solarized_termcolors = 256
let g:solarized_visability = "high"
let g:solarized_termtrans = 0
let g:solarized_contrast = "high"
"
" Enable syntastic statusline changes
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
if &term =~ '256color'
	" disable Background Color Erase (BCE) so that color schemes
	" render properly when inside 256-color tmux and GNU screen.
	" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
	set t_ut=
endif
"
" colemak remapping
noremap n j|noremap <C-w>n <C-w>j|noremap <C-w><C-n> <C-w>j
noremap e k|noremap <C-w>e <C-w>k|noremap <C-w><C-e> <C-w>k
noremap s h
noremap t l
noremap f e
noremap k n
noremap K N 
noremap U <C-r>
