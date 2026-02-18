Invoke-Expression (&starship init powershell)

$env:EDITOR = "nvim.exe"
# --------------------------
# Key bindings (PSReadLine)
# --------------------------
# While PowerShell doesn’t support mode-based key bindings like fish’s vi mode, you can
# customize PSReadLine key handlers. For example, to bind Ctrl+F to forward-char:

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# -------------------------
# Aliases (simple mappings)
# --------------------------
Set-Alias lg "C:\ProgramData\chocolatey\lib\lazygit\tools\lazygit.exe"
Set-Alias l eza.exe
Set-Alias bat bat.exe
# Set-Alias gh gh.exe
Set-Alias git git.exe
Set-Alias gw "git worktree"
Set-Alias vim nvim.exe

function la { eza.exe -a @args }
function ll { eza.exe -lah @args }
function ls { eza.exe --color=auto @args }
function time { cmd.exe /c TIME /t }

function New-EditablePr {
    [CmdletBinding()]
    param(
        [string] $Base = 'master'
    )

    # 1) Detect current branch
    $branch = Get-CurrentBranch
    if (-not $branch) {
        Write-Error "❌ Could not detect current branch. Are you in a git repo?"
        return
    }

    # 2) Extract JIRA issue from branch (e.g., DESKTOP_1234_Backport -> DESKTOP-1234)
    $jiraIssue = Get-JiraIssue $branch

    # 3) Parse base branch (handle both "remote/branch" and "branch" formats)
    $baseRemote = $null
    $baseBranch = $Base

    # Check if base already includes remote (e.g., "if/stable/25.3")
    $remotes = & git remote
    foreach ($remote in $remotes) {
        if ($Base -like "$remote/*") {
            $baseRemote = $remote
            $baseBranch = $Base.Substring($remote.Length + 1)
            break
        }
    }

    # If no remote prefix found, try to find which remote has this branch
    if (-not $baseRemote) {
        foreach ($remote in $remotes) {
            $remoteBranches = & git branch -r | Where-Object { $_ -match "$remote/$Base" }
            if ($remoteBranches) {
                $baseRemote = $remote
                break
            }
        }
    }

    if (-not $baseRemote) {
        Write-Error "❌ Could not find remote tracking branch for '$Base'."
        return
    }

    # 4) Update remote base branch
    Write-Host "📡 Fetching latest '$baseRemote/$baseBranch'..."
    & git fetch $baseRemote $baseBranch 2>&1 | Out-Null

    # 5) Bail if no commits ahead of base
    $ahead = & git rev-list --count "$baseRemote/$baseBranch..$branch" 2>$null
    if (-not $ahead -or $ahead -eq 0) {
        Write-Error "❌ No commits between '$baseRemote/$baseBranch' and '$branch'."
        return
    }
    Write-Host "✅ Found $ahead commit(s) ahead of '$baseRemote/$baseBranch'"

    # 6) Build title/header/body-file
    $summary = jsummary
    $title   = "$($jiraIssue): $($summary)"
    $link    = "[#$jiraIssue](https://initialforce.atlassian.net/browse/$jiraIssue)"
    $header  = @"
$link

#$jiraIssue
"@
    $commits = & git log --grep $jiraIssue --pretty=format:"%H %s%n%b" --no-merges | Out-String
    $tmp = Join-Path $env:TEMP "$branch-pr.md"
    ($header + $commits) | Set-Content $tmp -Encoding UTF8
    & $env:EDITOR $tmp

    # 7) Metadata & diagnostics
    $assignee  = 'stianeklund'
    $reviewers = 'l3oferreira','oysteinkrog'
    Write-Host "`n📝 Title     : $title"
    Write-Host "🔗 Jira link : $link"
    Write-Host "👤 Assignee  : $assignee"
    Write-Host "👥 Reviewers : $($reviewers -join ', ')" -ForegroundColor Cyan

    # 8) Push your branch (detect or default remote)
    $remoteName = (& git config branch.$branch.remote)
    if (-not $remoteName) { $remoteName = 'my' }
    Write-Host "🚀 Pushing '$branch' to '$remoteName'…"
    & git push -u $remoteName $branch
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ git push to '$remoteName' failed (exit code $LASTEXITCODE). Aborting."
        return
    }

    # 9) Get fork owner from remote URL for cross-repo PR
    $remoteUrl = & git remote get-url $remoteName
    $forkOwner = $null
    if ($remoteUrl -match 'github\.com[:/]([^/]+)/') {
        $forkOwner = $matches[1]
    }
    $headRef = if ($forkOwner) { "${forkOwner}:${branch}" } else { $branch }

    # 10) Create the PR!
    $prArgs = @(
        'pr','create',
        '--base',     $baseBranch,
        '--head',     $headRef,
        '--title',    $title,
        '--body-file',$tmp,
        '--assignee', $assignee
    )
    foreach ($r in $reviewers) {
        $prArgs += '--reviewer'; $prArgs += $r
    }

    & gh.exe @prArgs

    # 11) Cleanup
    Remove-Item $tmp -ErrorAction SilentlyContinue
}


Set-Alias epr New-EditablePr

function New-AutoPr {
    [CmdletBinding()]
    param(
        # If you ever want to target a non-master base, pass it here:
        [string] $Base = 'master'
    )

    # 1) Gather branch & Jira summary
    $branch  = Get-CurrentBranch
    $jiraIssue = Get-JiraIssue $branch
    $summary = jsummary
    $title   = "$($jiraIssue): $($summary)"

    # 2) Build the link and full body
    $link = "[#$jiraIssue](https://initialforce.atlassian.net/browse/$jiraIssue)"
    $body = @"
$link

#$jiraIssue

ManagedLicensing was removed in some previous builds but the consensus
per Foresight is that we should be using the managed licensing not
native if possible.

DeviceAPI (internally) when validating it has a check for whether
ManagedLicensing is set, if not set it will use p/invoke calls to their
native C++ validation lib, which I guess which may be buggy?

These changes re-enable ManagedLicensing

For history see commits:

* 34c3bb08f22fbaa5220954095526be960d93a12c
* 2b20c1e70e01327311c605cfbea7c61e0afebcb4
"@

    # 3) Metadata
    $assignee  = 'stianeklund'
    $reviewers = 'l3oferreira','oysteinkrog'

    # 4) Echo so you can verify
    Write-Host ''
    Write-Host "📝  Title     : $title"
    Write-Host "🔗  Jira link : $link"
    Write-Host "👤  Assignee  : $assignee"
    Write-Host "👥  Reviewers : $($reviewers -join ', ')"
    Write-Host ''
    Write-Host "📄  Body preview:"
    $body.Split("`n")[0..4] | ForEach-Object { Write-Host "    $_" }
    Write-Host "    …"
    Write-Host ''

    # 5) Finally, invoke gh with all flags in one go
    gh.exe pr create `
      --base   $Base `
      --head   $branch `
      --title  $title `
      --body   $body `
      --assignee $assignee `
      $(foreach ($r in $reviewers) { "--reviewer"; $r }) `
      @()
}

Set-Alias apr New-AutoPr

# --------------------------
# Functions for directory shortcuts
# --------------------------
function stable {
    Set-Location "D:\dev\work\worktrees"
}

function master {
    Set-Location "D:\dev\work\ScDesktop"
}

# --------------------------
# Git-related functions
# --------------------------
# Returns the current branch name (similar to your fish branch function)
function Get-CurrentBranch {
    $branchLine = git branch 2>$null | Where-Object { $_ -match '^\* ' }
    if ($branchLine -match '^\* (.+)$') {
        return $matches[1]
    }
}

# Extracts JIRA issue from branch name
# Handles both: DESKTOP-11086_backport and DESKTOP_11086_backport -> DESKTOP-11086
function Get-JiraIssue {
    param(
        [string]$BranchName
    )

    # Try hyphenated format first (DESKTOP-11086)
    if ($BranchName -match '^([A-Z]+)-(\d+)') {
        return "$($matches[1])-$($matches[2])"
    }
    # Try underscore format (DESKTOP_11086)
    if ($BranchName -match '^([A-Z]+)_(\d+)') {
        return "$($matches[1])-$($matches[2])"
    }
    # Fallback: return the branch name as-is if no pattern match
    return $BranchName
}

# Shows diff for first commit matching a JIRA ticket pattern
function showDiff {
    param(
        [Parameter(Mandatory=$true)]
        [string]$pattern
    )
    $hash = git log --grep=$pattern --pretty=format:'%h' -n 1
    if ($hash) {
        git show $hash
    } else {
        Write-Host "No matching commit found." -ForegroundColor Yellow
    }
}

# Returns current branch (for convenience)
function branch {
    Get-CurrentBranch
}

# Jira terminal integration functions
function jdetail {
    param(
        [string]$branchname
    )
    if ($branchname) {
        $issue = Get-JiraIssue $branchname
        jira-terminal detail $issue
    } else {
        $issue = Get-JiraIssue (Get-CurrentBranch)
        jira-terminal detail $issue
    }
}

function jstatus {
    param(
        [string]$branchname
    )
    if ($branchname) {
        $issue = Get-JiraIssue $branchname
        jira-terminal detail -f status $issue
    } else {
        $issue = Get-JiraIssue (Get-CurrentBranch)
        jira-terminal detail -f status $issue
    }
}

function jsummary {
    $issue = Get-JiraIssue (Get-CurrentBranch)
    jira-terminal detail -f summary $issue
}

# Abbreviation-style function: getprtitle (echo current branch and title, then copy to clipboard)
function getprtitle {
    $branch = Get-CurrentBranch
    $jiraIssue = Get-JiraIssue $branch
    $summary = jsummary

    "${jiraIssue}: ${summary}" | Set-Clipboard
    Write-Host "Copied to clipboard:" "{$jiraIssue}: {$summary}"
}


function gs { git status }
function gcv { git commit --verbose }
function gap { git add --patch }
function grup { git remote update }
function grbc { git rebase --continue }
function grh { git reset --hard @args }
function gco { git checkout @args }
function gcob { git checkout --branch @args }
function gcop { git checkout --patch }
function gcp { git cherry-pick @args }
function gri { git rebase --interactive @args }
function gsp { git stash pop }
function gst { git stash }


function gpu {
    param(
        [string]$Branch
    )

    if (-not $Branch) {
        $Branch = currentbranch
    }

    git push -u my $Branch
}

function gpuf {
    param(
        [string]$Branch
    )

    if (-not $Branch) {
        $Branch = currentbranch
    }

    git push -u my $Branch --force-with-lease
}

# Interactive git rebase alias
function gri {
    Write-Host "git rebase -i HEAD~N"
    $n = Read-Host "Enter number of commits for N"
    if ([int]::TryParse($n, [ref]0)) {
        git rebase -i "HEAD~$n"
    } else {
        Write-Host "Invalid number." -ForegroundColor Red
    }
}

# currentbranch function alias for branch
function currentbranch {
    Get-CurrentBranch
}

# --------------------------
# Environment variables and PATH modifications
# --------------------------
$env:JIRA_API_TOKEN = $env:JIRA_API_TOKEN  # set in environment, not here

# Initialize starship prompt for PowerShell
#Invoke-Expression (& starship init powershell)

