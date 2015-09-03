#!/bin/bash

ln -s gitconfig ~/.gitconfig
ln -s gitrc ~/.gitrc

echo "source ~/.gitrc/git-completion.sh" >> ~/.bash_profile
echo "source ~/.gitrc/git-prompt-settings.sh" >> ~/.bash_profile
