#!/bin/sh

# Symlink dotfiles from ~/.dotfiles to their expected locations
set -e

DIR="$HOME/.dotfiles"

link() {
    src="$DIR/$1"
    dest="$2"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "  backup: $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "  linked: $dest -> $src"
}

echo "==> Creating symlinks"
link config.fish "$HOME/.config/fish/config.fish"
link .gitconfig "$HOME/.gitconfig"
link .tmux.conf "$HOME/.tmux.conf"
link nvim/init.vim "$HOME/.config/nvim/init.vim"
link .gitmessage "$HOME/.gitmessage"
link starship.toml "$HOME/.config/starship.toml"
link fish_plugins "$HOME/.config/fish/fish_plugins"

# Windows-side configs (only link if the target dirs exist)
WIN_HOME="/mnt/c/Users/${USER}"
if [ -d "$WIN_HOME" ]; then
    link .ideavimrc "$WIN_HOME/.ideavimrc"
    PS_DIR="$WIN_HOME/Documents/PowerShell"
    if [ -d "$PS_DIR" ]; then
        link Microsoft.PowerShell_profile.ps1 "$PS_DIR/Microsoft.PowerShell_profile.ps1"
    fi
    link glazewm/config.yaml "$WIN_HOME/.glzr/glazewm/config.yaml"
    link zebar/settings.json "$WIN_HOME/.glzr/zebar/settings.json"
    link zebar/.marketplace "$WIN_HOME/.glzr/zebar/.marketplace"
    link zebar/.migrations.json "$WIN_HOME/AppData/Roaming/zebar/.migrations.json"
    link zebar/starter "$WIN_HOME/AppData/Roaming/zebar/downloads/glzr-io.starter@0.0.0"
fi

# Fish
printf "Install fish? [y/N] "
read -r opt
case "$opt" in
    y|Y) sudo apt install -y fish
         echo "  Set default shell: chsh -s /usr/bin/fish" ;;
esac

# Tmux
printf "Install tmux? [y/N] "
read -r opt
case "$opt" in
    y|Y) sudo apt install -y tmux ;;
esac

# Neovim
printf "Install neovim? [y/N] "
read -r opt
case "$opt" in
    y|Y) sudo apt install -y neovim ;;
esac

# vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "==> Installing vim-plug"
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v nvim >/dev/null 2>&1; then
    echo "==> Installing vim plugins"
    nvim +PlugInstall +qall
fi

# TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "==> Installing TPM"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Starship prompt
if ! command -v starship >/dev/null 2>&1; then
    printf "Install starship prompt? [y/N] "
    read -r opt
    case "$opt" in
        y|Y) curl -sS https://starship.rs/install.sh | sh ;;
    esac
fi

# Fisher plugin manager for fish
if command -v fish >/dev/null 2>&1; then
    if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
        echo "==> Installing fisher"
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fi
    echo "==> Installing fish plugins"
    fish -c "fisher update"
fi

echo "==> Done"
