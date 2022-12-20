#!/usr/bin/env bash

SCRIPTDIR=`dirname ${BASH_SOURCE[0]}`
DIRPATH=`readlink -f $SCRIPTDIR`

echo "Install directory = $DIRPATH"

echo "Creating symbolic link for vimrc"
ln -sf $DIRPATH/.vimrc ~/.vimrc

echo "Creating config for ctags"
cat $DIRPATH/kotlin.ctags > $HOME/.ctags

echo "Pulling all git submodules"
cd $DIRPATH
git submodule update --init --recursive

echo "Installing plugins"
vim -c ":PlugInstall" -c ":qa!"

echo "Generating helptags"
vim -c ":silent! helptags $DIRPATH/ftdoc" -c ":qa!"

echo "TODO:"
echo "-Compile YCM"
