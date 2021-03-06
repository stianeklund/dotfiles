#/bin/sh

# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
############################

########## Variables

dir=~/.dotfiles
olddir=~/.dotfiles_old
files=".gitconfig .vim .oh-my-zsh .zsh .vimrc .viminfo .vimtags .dir_colors .tmux.conf .minttyrc .githelpers .zshrc .tmux.conf .spacemacs .profile"

##########

# create .dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the .dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing .dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/$file $olddir/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/$file
done
# Install Fish
read -p "Install Fish & oh-my-fish? Y/n" option
echo
case $option in
    y|Y) echo "Installing"
        sudo apt install fish
        if which curl >/dev/null; then
            curl -L https://get.oh-my.fish | fish
        else
            echo "curl not installed, aborting OMF installation";
        fi;;
    n|N) echo "No";;
    * ) echo "Invalid option";;
esac

# Install Rust
read -p "Install Rust? Y/n" option
echo
case $option in
    y|Y) echo "Yes, installing through Rustup";
        if which curl >/dev/null; then
            curl https://sh.rustup.rs -ssf | sh
        else
            echo "curl not installed, aborting";
        fi;;
    n|N) echo "No";;
    * ) echo "Invalid option";;
esac

# Install Workman?
read -p "Install Workman? 1: apt, 2: pkg-ng, n/N " option
echo
case "$option" in
    y|Y) echo "Yes"; sudo cp /home/stian/.dotfiles/workman/us /usr/share/X11/xkb/symbols/;;
    n|N ) echo "No";;
    * ) echo "Invalid option";;
esac

# Install Vim?
read -p "Install Vim? 1: apt, 2: pkg-ng, n/N " option
echo
case "$option" in
    1 ) echo "apt"; sudo apt install vim;;
    2 ) echo "pkg"; sudo pkg install vim;;
    n|N ) echo "No";;
    * ) echo "Invalid option";;
esac
# Install Vim plugins?
read -p "Install Vim plugins & oh-my-zsh? Y/n " option
echo
case "$option" in
    y|Y ) echo "Yes";
        echo "Installing Vundle";
        git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
        echo "Installing oh-my-zsh";
        git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh;
        vim +PluginInstall +qall;;
    n|n ) echo "No";;
    * ) echo "Invalid option";;
esac
# Install Tmux?
read -p "Install Tmux? 1: apt, 2: pkg-ng n/N " option
echo
case "$option" in
    1 ) echo "Apt"; sudo apt install tmux;;
    2) echo "Pkg"; sudo pkg install tmux;;
    n|n ) echo "No";;
    * ) echo "Invalid option";;
esac

# Install i3?
read -p "Install i3? 1: Apt, 2: pkg-ng, n/N " option
echo
case "$option" in
    1) echo "Apt"; sudo apt install i3 i3blocks;
        echo "Setting wallpaper"
        feh --bg-scale /home/stian/.dotfiles/wallpapers/wallpaper.png;;
    2) echo "pkg"; sudo pkg install i3 i3blocks;;
    n|N ) echo "No";;
    * ) echo "Invalid option";;
esac
