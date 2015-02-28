set nocompatible              " be iMproved, required
set number
set backspace=2
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

execute pathogen#infect()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"
"	
" The sparkup vim script is in a subdirectory of this repo called vim.
"
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Colemak plugin
Plugin 'git://github.com/jooize/vim-colemak.git'

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
" Fix for colemak.vim keymap collision. tpope/vim-fugitive's maps y<C-G>
" and colemak.vim maps 'y' to 'w' (word). In combination this stalls 'y'
" because Vim must wait to see if the user wants to press <C-G> as well.
augroup RemoveFugitiveMappingForColemak
	autocmd!
	autocmd BufEnter * silent! execute "nunmap <buffer> <silent> y<C-G>"
augroup END

" Reload colemak.vim to remap any overridden keys
silent! source "$HOME/.vim/bundle/vim-colemak/plugin/colemak.vim"
