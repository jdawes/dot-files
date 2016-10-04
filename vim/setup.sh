#!/bin/bash

# Copy Vundle to directory
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

curdir=`pwd`

# Symlink vimrc to correct location
ln -s "${curdir}/vimrc" ~/.vimrc
ln -s "${curdir}/colors" ~/.vim/colors

# Install Vundle and plugins
 vim +PluginInstall +qall
