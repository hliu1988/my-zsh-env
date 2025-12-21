#!/bin/bash
# Init & Update oh-my-zsh, plugins and themes

[ -z $z ] && echo "error, empty \$z" && exit 1
export ZSH=$z/.oh-my-zsh

echo ""
echo "--------------- updating oh-my-zsh ... ---------------"

if [[ ! -d $ZSH || ! -d $ZSH/plugins ]]; then
    CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    cd $ZSH
    timeout 20 git pull
    cd -
fi

DIR_P_10k=${ZSH_CUSTOM:=$ZSH/custom}/themes/powerlevel10k
DIR_AUTO_S=${ZSH_CUSTOM:=$ZSH/custom}/plugins/zsh-autosuggestions
DIR_SYN_H=${ZSH_CUSTOM:=$ZSH/custom}/plugins/zsh-syntax-highlighting
DIR_FSYN_H=${ZSH_CUSTOM:=$ZSH/custom}/plugins/fast-syntax-highlighting
DIR_COMP=${ZSH_CUSTOM:=$ZSH/custom}/plugins/zsh-completions
DIR_FZF_TAB=${ZSH_CUSTOM:=$ZSH/custom}/plugins/fzf-tab
DIR_HIS_SUB=${ZSH_CUSTOM:=$ZSH/custom}/plugins/zsh-history-substring-search

GIT_REPO_P_10k=https://github.com/romkatv/powerlevel10k.git
GIT_REPO_AUTO_S=https://github.com/zsh-users/zsh-autosuggestions.git
GIT_REPO_SYN_H=https://github.com/zsh-users/zsh-syntax-highlighting.git
GIT_REPO_FSYN_H=https://github.com/zdharma-continuum/fast-syntax-highlighting.git #https://github.com/zdharma/fast-syntax-highlighting.git
GIT_REPO_COMP=https://github.com/zsh-users/zsh-completions
GIT_REPO_HIS_SUB=https://github.com/zsh-users/zsh-history-substring-search.git

echo ""
echo "--------------- updating powerlevel10k ... ---------------"
if [ ! -d $DIR_P_10k ]; then
    timeout 20 git clone --depth=1 $GIT_REPO_P_10k $DIR_P_10k
else
    cd $DIR_P_10k
    timeout 20 git pull
    cd -
fi

echo ""
echo "--------------- updating zsh-autosuggestions ... ---------------"
if [ ! -d $DIR_AUTO_S ]; then
    timeout 20 git clone --depth=1 $GIT_REPO_AUTO_S $DIR_AUTO_S
else
    cd $DIR_AUTO_S
    timeout 20 git pull
    cd -
fi

# echo ""
# echo "--------------- updating zsh-syntax-highlighting ... ---------------"
# if [ ! -d $DIR_SYN_H ]; then
#     git clone --depth=1 $GIT_REPO_FSYN_H $DIR_SYN_H
# else
#     git -C $DIR_SYN_H pull
# fi

echo ""
echo "--------------- updating fast-syntax-highlighting ... ---------------"
if [ ! -d $DIR_FSYN_H ]; then
    timeout 20 git clone --depth=1 $GIT_REPO_FSYN_H $DIR_FSYN_H
else
    cd $DIR_FSYN_H
    timeout 20 git remote set-url origin $GIT_REPO_FSYN_H
    timeout 20 git pull
    cd -
fi

echo ""
echo "--------------- updating zsh-completions ... ---------------"
if [ ! -d $DIR_COMP ]; then
    timeout 20 git clone --depth=1 $GIT_REPO_COMP $DIR_COMP
else
    cd $DIR_COMP
    timeout 20 git pull
    cd -
fi

echo ""
echo "--------------- updating zsh-history-substring-search ... ---------------"
if [ ! -d $DIR_HIS_SUB ]; then
    timeout 20 git clone --depth=1 $GIT_REPO_HIS_SUB $DIR_HIS_SUB
else
    cd $DIR_HIS_SUB
    timeout 20 git pull
    cd -
fi

