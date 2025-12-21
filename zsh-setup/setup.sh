#!/bin/bash

export e=$(cd $(dirname $0)/.. && pwd)
export ZDOTDIR=$(realpath "$e/../my-dot-file")
export w=$(realpath "$e/../..")
export z="$ZDOTDIR"
mkdir -p "$z"

cd "$e"
cd "$z"
cp "$e"/zsh-setup/dotfile/zshenv "$z/.zshenv"
rm -rf ~/.zshenv
ln -s "$z/.zshenv" ~/.zshenv

echo
echo "--------------- Setting ZSH Env ... ---------------"

if [ $(uname) = "Darwin" ]; then
    OS="macos"
else
    grep ubuntu /etc/os-release >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        OS="ubuntu"
    else
        OS="centos"
    fi
fi

# set -e
# set -x

# 1. zsh theme
INSTALL_CMD=
if ! which zsh >/dev/null; then
    if [ "$OS" == "ubuntu" ]; then
        sudo apt install zsh
        INSTALL_CMD="sudo apt"
    elif [ $OS == "centos" ]; then
        yes y | sudo yum install zsh
        INSTALL_CMD="sudo dnf"
    else
        sudo brew install zsh
    fi
fi

if [ ! -d $z/.oh-my-zsh ] || [ ! -d $z/.oh-my-zsh/plugins ]; then
    $e/zsh-setup/setup-ohmyzsh.sh
fi

touch ~/.z # initialization for plugin "z"
mkdir -p $z/bak
touch $z/env.zsh

cp $e/zsh-setup/dotfile/zshrc.zsh $z/.zshrc
cp $e/zsh-setup/dotfile/fzf.zsh $z/.fzf.zsh
cp $e/misc-script/proxy.sh $z/

# cp $e/zsh-setup/dotfile/zshenv $z/.zshenv
# rm -rf $HOME/.zshenv
# ln -s $z/.zshenv $HOME/.zshenv

# if [[ "x$OS" = "xmacos" ]]; then
#     sed -i "" "s|%{ZSH_ENV_ROOT}|$e|g" $z/.zshrc # fix MacOS sed (must give a backup name, here is "" to avoid backup)
# else
sed -i "s|%{ZSH_ENV_ROOT}|$e|g" $z/.zshrc
# fi

if [ ! -d $z/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $z/.fzf
fi
# git config --global core.excludesfile $e/setting/gitignore-global
# git config --global credential.helper cache
echo "Setup ZSH Theme and Enviroments OK"
