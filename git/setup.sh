dir=$(pwd)

ln -s $dir/gitconfig ~/.gitconfig
ln -s $dir/gitrc ~/.gitrc
ln -s $dir/git_template ~/.git_template

echo "source ~/.gitrc/git-completion.sh" >> ~/.bash_profile
echo "source ~/.gitrc/git-prompt-settings.sh" >> ~/.bash_profile
