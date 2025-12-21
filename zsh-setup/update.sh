#!/bin/bash

# 1. git update
echo ""
echo "--------------- updating repo ... ---------------"
PUSH=${PUSH:-y}
cd $e

if [ "$PUSH" == y ]; then
    if [ $# -gt 0 ]; then
        MSG="$@"
    else
        MSG="xx"
    fi

    git add -A
    git commit -m "$MSG"
    git pull --rebase

    echo ""
    echo "--------------- pushing repo ... ---------------"
    git push # --set-upstream origin master
else
    if [ "$CLEAR" == y ]; then
        git reset --hard
        git pull --rebase
    else
        git stash
        git pull --rebase
        git stash pop
    fi
fi

if [ "$ALL" == y ]; then
    zsh/setup-ohmyzsh.sh
fi

sh $e/zsh-setup/setup.sh
