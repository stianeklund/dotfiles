fish_vi_key_bindings

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

# use windows git or linux variant depending on path
function git --wraps git
  if pwd -P | grep -q "^\/mnt\/*\/*"
    git.exe $argv
  else
    command git $argv
  end
end

alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'
alias bat='bat.exe'
alias gh='gh.exe'

function stable
  cd /mnt/e/dev/work/stable/10.0
end

function master
  cd /mnt/e/dev/work/scdesktop
end

# shows diff (first matched) jira ticket
function showDiff
  set HASH (git log --grep=$argv --pretty=format:'%h' -n 1)
  git show $HASH
end

function branch
    command git branch | sed -n '/\* /s///p'
end

function jdetail --argument-names 'branchname'
    if test -n "$branchname"
        jira-terminal detail $branchname
    else
        jira-terminal detail (branch)
    end
end

function jstatus --argument-names 'branchname'
    if test -n "$branchname"
        jira-terminal detail -f status $branchname
    else
        jira-terminal detail -f status (branch)
    end
end

function jsummary
    jira-terminal detail -f summary (branch)
end

starship init fish | source
