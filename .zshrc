# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Pretty colors
set -g default-terminal "xterm-256color"
#eval `dircolors ~/.dir_colors`

# Oh my ZSH theme
ZSH_THEME="robbyrussell"

ENABLE_CORRECTION="true"

# Turn off auto titles, annoying as hell
DISABLE_AUTO_TITLE="true"
# Display grep matches in green
export GREP_COLOR='0;32'
export GREP_OPTIONS='--color=auto'

# Allow ANSI colors in less output
alias less='less -R'

# Colored man pages!
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
    }
# Plugins
plugins=(git tmux colorize)

# User configuration
export PATH="/usr/local/bin:$PATH"
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8
export TERM=xterm-256color
#eval "$(hub alias -s)" # hub alias to git

# tmux aliases
alias tmux='tmux -2'
alias ta='tmux attach'
alias tnew='tmux new -s'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'

# cargo aliases
alias cb='cargo build'
alias cr='cargo run'
# set keymap to US International
# setxkbmap -layout us -variant altgr-intl -option nodeadkeys
# setxkbmap -v us -variant workman-intl && xset -r 66
