# ~/.config/fish/config.fish

# Key bindings
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

# WSL-aware git wrapper
function git --wraps git
    if string match -qr "^/mnt/[A-Za-z]/" (pwd -P)
        git.exe $argv
    else
        command git $argv
    end
end

# Aliases as functions
function lg
    /mnt/c/ProgramData/chocolatey/lib/lazygit/tools/lazygit.exe $argv
end

function ls
    exa --color=auto $argv
end

function la
    exa -a $argv
end

function ll
    exa -lah $argv
end

function bat
    bat.exe $argv
end

function dotnet
    dotnet.exe $argv
end

function vim
    nvim $argv
end

# Project shortcuts
function stable
    cd /mnt/d/dev/work/stable/24.2
end

function master
    cd /mnt/d/dev/work/scdesktop
end

# Git/Jira utilities
function showDiff
    set -l HASH (git log --grep="$argv" --pretty=format:'%h' -n1)
    git show "$HASH"
end

function branch
    command git branch | sed -n '/\* /s///p'
end

function currentbranch
    echo (branch)
end

function jdetail --argument-names branchname
    if test -n "$branchname"
        jira-terminal detail $branchname
    else
        jira-terminal detail (branch)
    end
end

function jstatus --argument-names branchname
    if test -n "$branchname"
        jira-terminal detail -f status $branchname
    else
        jira-terminal detail -f status (branch)
    end
end

function jsummary
    jira-terminal detail -f summary (branch)
end

abbr getprtitle 'echo (branch): (jsummary) | clip.exe'

function gri
    echo git rebase -i HEAD~N
    echo Enter number of commits for N
    git rebase -i HEAD~(read)
end

function dos2unix-diff
    for file in (git diff --name-only)
        if test -f $file
            dos2unix $file
        end
    end
end

# Initialize starship prompt
starship init fish | source

# Environment and PATH
set -x BUN_INSTALL $HOME/.bun
set -x PATH \
    $HOME/.local/bin \
    $BUN_INSTALL/bin \
    /usr/bin \
    /usr/local/bin \
    /bin \
    $PATH

set -x DISPLAY 127.0.0.1:0.0
set -x EDITOR /usr/bin/nvim

# Claude settings
set -x CLAUDE_APP_PATH /usr/bin/claude
set -x CLAUDE_CONFIG_DIR $HOME/.claude

set -gx NODE_NOTIFIER_DISABLED 1

# Load secrets (API keys etc.) from a separate untracked file
if test -f ~/.config/fish/conf.d/secrets.fish
    source ~/.config/fish/conf.d/secrets.fish
end
