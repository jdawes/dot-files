#!/bin/bash

# Copy Vundle to directory
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

# Symlink vimrc to correct location
ln -s vimrc ~/.vimrc

# Install Vundle and plugins
vim +PluginInstall +qall
