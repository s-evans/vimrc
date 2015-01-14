#!/usr/bin/env bash

SCRIPTDIR=`dirname ${BASH_SOURCE[0]}`
DIRPATH=`readlink -f $SCRIPTDIR`

echo "Install directory = $DIRPATH"

echo "Creating symbolic link for vimrc"
ln -sf $DIRPATH/.vimrc ~/.vimrc

echo "Pulling all git submodules"
cd $DIRPATH
git submodule update --init --recursive

echo "Please compile YCM!"

