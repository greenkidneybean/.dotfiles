#!/usr/bin/env bash

# backup ~/ dotfiles to ~/.dotfiles_backup
# symlink dotfiles/* to ~/

echo "creating symlinks for project dotfiles..."
pushd dotfiles > /dev/null 2>&1
now=$(date +"%y%m%d.%H.%M")

for file in .*; do
  if [[ $file == "." || $file == ".." ]]; then
    continue
  fi
  echo "running ~/$file"
  # if the file exists:
  if [[ -e ~/$file ]]; then
      mkdir -p ~/.dotfiles_backup/$now
      mv ~/$file ~/.dotfiles_backup/$now/$file
      echo "backup saved as ~/.dotfiles_backup/$now/$file"
  fi
  # symlink might still exist
  unlink ~/$file > /dev/null 2>&1
  # create the link
  ln -s ~/.dotfiles/dotfiles/$file ~/$file
  echo '\tlinked'
done

popd > /dev/null 2>&1

# install zsh plugins
if [ -d ~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]
then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# check for vim-plug
if [ -d ~/.vim/autoload/plug.vim ]
then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
