#!/bin/bash

curdir=`pwd`

ln -s "${curdir}/gitconfig" ~/.gitconfig
ln -s "${curdir}/gitrc" ~/.gitrc

echo "source ~/.gitrc/git-completion.sh" >> ~/.bash_profile
echo "source ~/.gitrc/git-prompt-settings.sh" >> ~/.bash_profile
