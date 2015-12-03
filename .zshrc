# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Pretty colors
set -g default-terminal "screen-256color"

# Oh my ZSH theme
ZSH_THEME="robbyrussell"

ENABLE_CORRECTION="true"

# Display grep matches in green
export GREP_COLOR='0;32'
export GREP_OPTIONS='--color=auto'

# Allow ANSI colors in less output
alias less='less -R'

# Plugins
plugins=(git tmux colorize)

# User configuration
export PATH="/usr/local/bin:$PATH"
source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8
eval "$(hub alias -s)" # hub alias to git

# tmux aliases
alias tmux='tmux -2'
alias ta='tmux attach'
alias tnew='tmux new -s'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
