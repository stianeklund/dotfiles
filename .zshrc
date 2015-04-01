# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Pretty colors
set -g default-terminal "screen-256color"
#set -g default-terminal "screen-256color screen"
# Oh my ZSH theme
ZSH_THEME="chris"

ENABLE_CORRECTION="true"

# Display grep matches in green
export GREP_COLOR='0;32'
export GREP_OPTIONS='--color=auto'
# Allow ANSI colors in less output
alias less='less -R'
# Plugins
plugins=(git ruby tmux colemak colorize)
# User configuration
echo 'export PATH="/usr/local/bin:$PATH"'
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# tmux aliases
alias tmux='tmux -2'
alias ta='tmux attach -t'
alias tnew='tmux new -s'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
eval "$(hub alias -s)" # hub alias to git

