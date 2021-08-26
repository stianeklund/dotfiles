fish_vi_key_bindings

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'
alias bat='bat.exe'
alias jira='jira-terminal.exe'

abbr -a -g gri 'git rebase -i'
abbr -a -g gca 'git commit --amend -v'
abbr -a -g gd 'git diff'
abbr -a -g gs 'git status'

# git set upstream & push to $branch
abbr -a -g gpu 'git push -u my (currentbranch)'
abbr -a -g gpuf 'git push -u my (currentbranch) --force-with-lease'

# Jira helper functions
# Gets the git branch
function branch
    command git branch | sed -n '/\* /s///p'
end

function currentbranch
    set branch (git branch | sed -n '/\* /s///p')
    echo $branch
end

# Allowed transitions for DESKTOP-5977 are as below:
# - Rejected
# - Pull request is done
# - Delegate in other person
# - Pause the task

function jsetfixedversion
    jira update (currentbranch) --field fixVersions --value 9.7.0
end

function jdetail --argument-names 'branchname'
    if test -n "$branchname"
        jira detail $branchname
    else
        jira detail (currentbranch)
    end
end

function jstatus --argument-names 'branchname'
    if test -n "$branchname"
        jira detail -f status $branchname
    else
        jira detail -f status (currentbranch)
    end
end

# can be used to create PR titles if currentbranch is prefixed!
function jsummary
    jira detail -f summary (currentbranch)
end

# current sprint
function jsprint
    jira detail -f customfield_10010 (currentbranch)
end


# Ticket transitions

function jtrans --argument-names 'branchname'
    if test -n "$branchname"
        jira transition -l --ticket $branchname
    else
        jira transition -l --ticket (currentbranch)
    end
end

function jtur
    # jira transition "Pull request is done" --ticket (currentbranch)
    jira transition "Bug solved waiting code reviewing" --ticket (currentbranch)
    jstatus
end

function jas
    jira assign --ticket (currentbranch) --user "Stian Eklund"
    jira transition "Assigned person" --ticket (currentbranch)
    jstatus
end

function jtip
    set branch = (git branch | sed -n '/\* /s///p')
    jira-terminal.exe transition "Start to solve the bug" --ticket (currentbranch)
    jstatus
end

function jtfi
    set branch = (git branch | sed -n '/\* /s///p')
    jira transition "ToFixed" --ticket (currentbranch)
    jstatus
end

function jstart
    jira transition "Start to solve the bug" --ticket (currentbranch)
    jira transition "Developing the new feature" --ticket (currentbranch)
    jstatus
end


function jcomp --argument-names 'values'
    jira fields (currentbranch) --field components --value $values
    jira update (currentbranch) --field components --value $values
    jira detail --fields components (currentbranch)
    jstatus
end

function jsetresult --argument-names 'values'
    jira update (currentbranch) --field customfield_10048 --value $values
    jira detail --fields customfield_10048 (currentbranch)
end

function jhowtorepro --argument-names 'values'
    jira update (currentbranch) --field customfield_10047 --value $values
    jira detail --fields customfield_10047 (currentbranch)
end

function jstop
    set branch = (git branch | sed -n '/\* /s///p')
    jira transition "Stop Progress" --ticket (currentbranch)
    jstatus
end

function jclose --argument-names 'branchname'
    if test -n "$branchname"
        jira transition "Close step" --ticket $branchname
        jira detail -f status $branchname
    else
        jira transition "Close step" --ticket (currentbranch)
        jstatus
    end
end

starship init fish | source
