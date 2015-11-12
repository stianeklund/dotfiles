#/bin/sh

# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
############################

########## Variables

dir=~/.dotfiles
olddir=~/.dotfiles_old
files=".gitconfig .vim .oh-my-zsh .zsh .vimrc .pryrc .irbrc .viminfo .vimtags .dir_colors .tmux.conf .minttyrc .githelpers .lesskey .zshrc
tmux.conf .pentadactylrc"

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

# grab Vundle from github
echo "Grabbing Vundle for you.."
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "Grabbing oh-my-zsh.."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
echo "Running Vim :PluginInstall"
vim +PluginInstall +qall



