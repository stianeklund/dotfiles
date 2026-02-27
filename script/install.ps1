#Requires -RunAsAdministrator
# Symlink dotfiles from ~/.dotfiles to their expected locations on Windows

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$DotfilesDir = "$HOME\.dotfiles"

function Link {
    param([string]$Src, [string]$Dest)
    $fullSrc = Join-Path $DotfilesDir $Src
    if (Test-Path $Dest) {
        $bak = "$Dest.bak"
        Write-Host "  backup: $Dest -> $bak"
        Move-Item -Force $Dest $bak
    }
    $destDir = Split-Path $Dest -Parent
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }
    New-Item -ItemType SymbolicLink -Path $Dest -Target $fullSrc | Out-Null
    Write-Host "  linked: $Dest -> $fullSrc"
}

Write-Host "==> Creating symlinks"
Link ".gitconfig"                      "$HOME\.gitconfig"
Link ".gitmessage"                     "$HOME\.gitmessage"
Link ".ideavimrc"                      "$HOME\.ideavimrc"
Link "_vimrc"                          "$HOME\_vimrc"
Link "nvim\init.vim"                   "$HOME\AppData\Local\nvim\init.vim"
Link "starship.toml"                   "$HOME\.config\starship.toml"
Link "Microsoft.PowerShell_profile.ps1" "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
Link "glazewm\config.yaml"             "$HOME\.glzr\glazewm\config.yaml"
$ZebarPack = "$env:APPDATA\zebar\downloads\glzr-io.starter@0.0.0"
Link "zebar\with-glazewm.html"         "$ZebarPack\with-glazewm.html"
Link "zebar\styles.css"                "$ZebarPack\styles.css"
Link "zebar\zpack.json"                "$ZebarPack\zpack.json"

# Starship
if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
    $ans = Read-Host "Install starship prompt? [y/N]"
    if ($ans -match '^[yY]$') {
        winget install --id Starship.Starship -e
    }
}

# Neovim
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    $ans = Read-Host "Install neovim? [y/N]"
    if ($ans -match '^[yY]$') {
        winget install --id Neovim.Neovim -e
    }
}

Write-Host "==> Done"
