set nocompatible              " be iMproved, required
set number
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
set expandtab
set nowrap

filetype on                  " required
filetype indent on
filetype plugin on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call pathogen#helptags()
execute pathogen#infect()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'git://github.com/tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'git://github.com/scrooloose/syntastic.git'

call vundle#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

syntax enable
set background=dark
colorscheme solarized

" Solarized additions
let g:solarized_termcolors = 256
let g:solarized_visability = "high"
let g:solarized_termtrans = 0
let g:solarized_contrast = "high"

" Enable syntastic statusline changes
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
" Disable BCE for better 256 color support
if &term =~ '256color'
" disable Background Color Erase (BCE) so that color schemes
" render properly when inside 256-color tmux and GNU screen.
" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" vim-ruby
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" colemak remapping
noremap n j|noremap <C-w>n <C-w>j|noremap <C-w><C-n> <C-w>j
noremap e k|noremap <C-w>e <C-w>k|noremap <C-w><C-e> <C-w>k
noremap s h
noremap t l
noremap f e
noremap k n
noremap K N
noremap U <C-r>

