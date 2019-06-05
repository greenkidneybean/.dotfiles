#!/usr/bin/env bash

git clone https://github.com/greenkidneybean/.dotfiles
cd .dotfiles

ln -sv ".iterm2" ~
ln -sv ".condarc" ~
ln -sv ".gitconfig" ~
ln -sv ".tmux.conf" ~
ln -sv ".vimrc" ~
ln -sv ".zshrc" ~
