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
link .profile "$HOME/.profile"
link _vimrc "$HOME/_vimrc"
link .ideavimrc "$HOME/.ideavimrc"
link nvim/init.vim "$HOME/.config/nvim/init.vim"
link .gitmessage "$HOME/.gitmessage"

# PowerShell profile (Windows/WSL — only link if the target dir exists)
PS_DIR="/mnt/c/Users/${USER}/Documents/PowerShell"
if [ -d "$PS_DIR" ]; then
    link Microsoft.PowerShell_profile.ps1 "$PS_DIR/Microsoft.PowerShell_profile.ps1"
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

echo "==> Installing vim plugins"
nvim +PlugInstall +qall

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

echo "==> Done"
